use std::{
  env,
  fs::File,
  io::{BufRead, BufReader},
  process::{Command, Stdio},
  rc::Rc,
};

use which::which;

fn main() {
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

  let current_dir = env::current_dir().expect("Failed to get current dir");
  let readme_file = current_dir.join("../../README.md");
  let file_descriptor = File::open(readme_file).expect("Failed to open README.md");
  let reader = BufReader::new(file_descriptor);

  let home_dir = env::var_os("HOME").unwrap();
  let symlink_path = Path::new(&home_dir.to_str().unwrap())
    .join(".config/fish")
    .is_dir();

  match symlink_path {
    true => {
      println!("Symlink already exists");
      println!("Skipping....");
      thread::sleep(Duration::from_secs(1));
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
  let mut find_audio_pkgs = false;
  let mut pkgs = String::new();
  let mut audio_pkgs = String::new();
  for line in reader.lines() {
    if let Ok(text) = line {
      find_pkgs |= text.contains("yay -Syu");
      find_audio_pkgs |= text.contains("Audio");

      if find_pkgs {
        pkgs.push_str(&text);
      }
      if find_audio_pkgs {
        audio_pkgs.push_str(&text);
      }
      if text.contains("--needed") {
        find_pkgs = false;
      }

    } else {
      eprintln!("failed to read line");
    }
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

    let yay_install = yay_install
      .wait_with_output()
      .unwrap();

    unsafe { println!("{}", String::from_utf8_unchecked(yay_install.stdout)) };
  }

  let audio_pkgs = audio_pkgs.replace("```", "");
  let audio_pkgs = audio_pkgs.replace("\\", "");
  let audio_pkgs = audio_pkgs.replace("### Audio Packages | Optionalbash", "");

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

  let clear = Command::new("clear")
    .output()
    .expect("failed to clear the screen");

  unsafe { println!("{}", String::from_utf8_unchecked(clear.stdout)) };

  println!("Finished installing packages");

  println!("\nInstalling audio packages");

  let audio_pkgs = audio_pkgs.split_whitespace().skip(2).collect::<Rc<_>>();
  let install_audio_pkgs = Command::new("yay")
    .arg("-S")
    .args(audio_pkgs.iter())
    .stdin(Stdio::piped())
    .spawn()
    .expect("failed to install audio packages");

  let install_audio_pkgs = install_audio_pkgs
    .wait_with_output()
    .expect("failed to install audio packages");

  unsafe { println!("{}", String::from_utf8_unchecked(install_audio_pkgs.stdout)) };
}
