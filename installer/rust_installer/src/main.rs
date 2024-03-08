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

    let output = stow_install
      .wait_with_output()
      .expect("failed to install stow");

    println!("{}", String::from_utf8_lossy(&output.stdout));
  }

  // let _ = Command::new("stow")
  //   .args(&["*/", "-t", "~/"])
  //   .current_dir("../../../config/")
  //   .output()
  //   .expect("failed to link the config dirs");

  println!("Successfully link the config dirs");

  let current_dir = env::current_dir().expect("Failed to get current dir");
  let file_path = current_dir.join("../../README.md");
  let file_descriptor = File::open(file_path).expect("Failed to open README.md");
  let reader = BufReader::new(file_descriptor);

  let mut find_pkgs = false;
  let mut pkgs = String::new();
  for line in reader.lines() {
    if let Ok(text) = line {
      if text.contains("yay -Syu") {
        find_pkgs = true;
      }
      if find_pkgs {
        pkgs.push_str(&text);
      }
      if text.contains("--needed") {
        break;
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
      .output()
      .expect("failed to clone yay");
      .expect("failed to clone yay");

    println!("{}", String::from_utf8_lossy(&git_clone_yay.stdout));

    println!("Installing yay");
    let yay_install = Command::new("makepkg")
      .arg("-si")
      .current_dir("yay")
      .stdin(Stdio::piped())
      .output()
      .expect("failed to install yay");
      .expect("failed to install yay");

    println!("{}", String::from_utf8_lossy(&yay_install.stdout));
  }

  let pkgs = pkgs.replace("\\", "");
  println!("{}", pkgs);

  let pkgs = pkgs.split_whitespace().collect::<Rc<_>>();
  pkgs.into_iter().skip(2).for_each(|pkg| {
    let _ = Command::new("yay")
      .args(&["-Syu", pkg])
      .stdin(Stdio::piped())
      .output()
      .expect("failed to install packages");
  });
}
