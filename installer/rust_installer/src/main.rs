use std::{
  env,
  fs::{self, File},
  io::{stdin, BufRead, BufReader},
  path::Path,
  process::{Command, Stdio},
};

use which::which;

fn main() {
  print!("\x1B[2J\x1B[1;1H");

  println!("Starting the installer");

  let find_stow = which("stow");
  if let Err(_) = find_stow {
    println!("Installing stow");

    let stow_install = Command::new("sudo")
      .args(&["pacman", "-S", "stow", "--noconfirm"])
      .stdout(Stdio::piped())
      .stdin(Stdio::piped())
      .spawn()
      .expect("Failed to install stow");

    let stow_install = stow_install
      .wait_with_output()
      .expect("Failed to install stow");

    unsafe { println!("{}", String::from_utf8_unchecked(stow_install.stdout)) };
  }

  let current_path = env::current_dir().expect("Failed to get current directory");
  let mut readme_path = "../../README.md";
  let mut config_dir = "../../config";
  if current_path.to_str().unwrap().contains("bin") {
    readme_path = "../../../README.md"; 
    config_dir = "../../../config";
  }

  let readme_file = current_path.join(readme_path);
  let file_descriptor = File::open(readme_file).expect("Failed to open README.md");

  let reader = BufReader::new(file_descriptor);
  let home_dir = env::var_os("HOME").expect("couldn't load HOME environment variable");
  let fish_shell = Path::new(&home_dir.to_str().unwrap())
    .join(".config/fish")
    .is_dir();

  match fish_shell {
    true => {
      println!("\nSymlink already exists");
      println!("Skipping....\n");
    }
    false => {
      let _ = Command::new("stow")
        .args(&["*/", "-t", "~/"])
        .current_dir(config_dir)
        .output()
        .unwrap();

      println!("Successfully link the config dirs");
    }
  };
  drop(home_dir);

  let mut find_pkgs = false;
  let mut find_amd_drivers = false;
  let mut pkgs = String::new();
  let mut amd_drivers = String::new();
  for line in reader.lines() {
    match line {
      Ok(text) => {
        find_pkgs |= text.contains("yay -Syu");
        find_amd_drivers |= text.contains("AMD");

        if find_pkgs {
          pkgs.push_str(&text);
        }
        if find_amd_drivers {
          amd_drivers.push_str(&text);
        }

        if text.contains("--needed") {
          find_pkgs = false;
        }
      }
      Err(err) => eprintln!("Failed to read line: {}", err),
    };
  }

  let find_yay = which("yay");
  if let Err(_) = find_yay {
    println!("Cloning yay");

    let git_clone_yay = Command::new("git")
      .args(&["clone", "https://aur.archlinux.org/yay.git"])
      .spawn()
      .expect("Failed to clone yay");

    let git_clone_yay = git_clone_yay
      .wait_with_output()
      .expect("Failed to clone yay");

    unsafe { println!("{}", String::from_utf8_unchecked(git_clone_yay.stdout)) };

    println!("Installing yay");
    let yay_install = Command::new("makepkg")
      .arg("-si")
      .current_dir("yay")
      .stdin(Stdio::piped())
      .spawn()
      .unwrap();

    let yay_install = yay_install.wait_with_output().unwrap();

    unsafe { println!("{}", String::from_utf8_unchecked(yay_install.stdout)) };

    println!("\nRemoving yay directory");
    if let Err(err) = fs::remove_dir_all("yay") {
      eprintln!("Failed to remove yay directory: {}", err);
    }
  }

  let pkgs = pkgs.replace("\\", "");

  let pkgs = pkgs.split_whitespace().skip(2);
  let install_pkgs = Command::new("yay")
    .arg("-Syu")
    .args(pkgs)
    .stdin(Stdio::piped())
    .spawn()
    .expect("Failed to install packages");

  let install_pkgs = install_pkgs
    .wait_with_output()
    .expect("Failed to install packages");

  unsafe { println!("{}", String::from_utf8_unchecked(install_pkgs.stdout)) };

  print!("\x1B[2J\x1B[1;1H");

  println!("Finished installing packages");

  let sys_services = ["bluetooth", "ly"];

  println!("\nEnabling services\n");
  for service in sys_services {
    let status = Command::new("sudo")
      .args(&["systemctl", "enable", service])
      .spawn()
      .unwrap();

    let status = status.wait_with_output().unwrap();

    unsafe { println!("{}", String::from_utf8_unchecked(status.stdout)) };
  }

  println!("\nInstall AMD Drivers?");
  println!("[y/n]\n");
  let mut user_option = String::new();
  stdin().read_line(&mut user_option).expect("Failed to read line");

  if user_option.trim() == "y" {
    let amd_drivers = amd_drivers.split_whitespace().skip(2);
    let output = Command::new("yay")
      .arg("-S")
      .args(amd_drivers)
      .spawn()
      .unwrap();

    let output = output.wait_with_output().unwrap();
    unsafe { println!("{}", String::from_utf8_unchecked(output.stdout)) };
  }

  println!("\nDone!");
}
