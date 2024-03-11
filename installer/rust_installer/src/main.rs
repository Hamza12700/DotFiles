use std::{
  env,
  fs::{self, File},
  io::{BufRead, BufReader},
  path::Path,
  process::{Command, Stdio},
  rc::Rc,
};

use which::which;

fn main() {
  let claer = Command::new("clear").output().unwrap();
  unsafe { println!("{}", String::from_utf8_unchecked(claer.stdout)) };

  println!("Starting the installer");

  let find_stow = which("stow");
  if let Err(_) = find_stow {
    println!("Installing stow");

    let stow_install = Command::new("sudo")
      .args(&["pacman", "-S", "stow", "--noconfirm"])
      .stdout(Stdio::piped())
      .stdin(Stdio::piped())
      .spawn()
      .expect("failed to install stow");

    let stow_install = stow_install
      .wait_with_output()
      .expect("failed to install stow");

    unsafe { println!("{}", String::from_utf8_unchecked(stow_install.stdout)) };
  }

  let current_dir = env::current_dir().unwrap();
  let parrent_dir = current_dir.parent().unwrap();
  if parrent_dir.file_name().unwrap() == "bin" {
    if let Err(err) = env::set_current_dir(parrent_dir.join("..")) {
      eprintln!("Failed to change directory: {}", err);
      std::process::exit(1);
    }
  }
  let readme_file = current_dir.join("../../README.md");
  let file_descriptor = File::open(readme_file).expect("Failed to open README.md");
  let reader = BufReader::new(file_descriptor);

  let home_dir = env::var_os("HOME").unwrap();
  let symlink_path = Path::new(&home_dir.to_str().unwrap())
    .join(".config/fish")
    .is_dir();

  match symlink_path {
    true => {
      println!("\nSymlink already exists");
      println!("Skipping....\n");
    }
    false => {
      let _ = Command::new("stow")
        .args(&["*/", "-t", "~/"])
        .current_dir("../../../config/")
        .output()
        .unwrap();

      println!("Successfully link the config dirs");
    }
  };
  drop(home_dir);

  let mut find_pkgs = false;
  let mut pkgs = String::new();
  for line in reader.lines() {
    match line {
      Ok(text) => {
        find_pkgs |= text.contains("yay -Syu");

        if find_pkgs {
          pkgs.push_str(&text);
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
      .expect("failed to clone yay");

    let git_clone_yay = git_clone_yay
      .wait_with_output()
      .expect("failed to clone yay");

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

  let pkgs: Rc<_> = pkgs.split_whitespace().skip(2).collect();
  let install_pkgs = Command::new("yay")
    .arg("-Syu")
    .args(pkgs.iter())
    .stdin(Stdio::piped())
    .spawn()
    .expect("failed to install packages");

  let install_pkgs = install_pkgs
    .wait_with_output()
    .expect("failed to install packages");

  unsafe { println!("{}", String::from_utf8_unchecked(install_pkgs.stdout)) };
  drop(pkgs);

  let clear = Command::new("clear").output().unwrap();

  unsafe { println!("{}", String::from_utf8_unchecked(clear.stdout)) };

  println!("Finished installing packages");
}
