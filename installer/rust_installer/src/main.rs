use std::{
  fs,
  process::{Command, Stdio},
};

use which::which;

fn main() {
  print!("\x1B[2J\x1B[1;1H");

  println!("Starting the installer");

  if let Err(_) = which("stow") {
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

  let packages_list =
    fs::read_to_string("packages/package.txt").expect("Failed to open packages file");

  if let Err(_) = which("paru") {
    println!("Cloning paru");

    let git_clone_paru = Command::new("git")
      .args(&["clone", "https://aur.archlinux.org/paru.git"])
      .spawn()
      .expect("Failed to clone paru");

    let git_clone_paru = git_clone_paru
      .wait_with_output()
      .expect("Failed to clone paru");

    unsafe { println!("{}", String::from_utf8_unchecked(git_clone_paru.stdout)) };

    println!("Installing paru");
    let paru_install = Command::new("makepkg")
      .arg("-si")
      .current_dir("paru")
      .stdin(Stdio::piped())
      .stdout(Stdio::piped())
      .spawn()
      .unwrap();
    let yay_install = paru_install.wait_with_output().unwrap();
    unsafe { println!("{}", String::from_utf8_unchecked(yay_install.stdout)) };

    println!("\nRemoving paru git directory");
    if let Err(err) = fs::remove_dir_all("paru") {
      eprintln!("Failed to remove paru git directory: {}", err);
    }
  }

  let pkgs = packages_list.replace("\\", "");
  let install_pkgs = Command::new("paru")
    .arg("-S")
    .args(pkgs.split_whitespace())
    .stdin(Stdio::piped())
    .stdout(Stdio::piped())
    .spawn()
    .expect("Failed to install packages");

  let install_pkgs = install_pkgs
    .wait_with_output()
    .expect("Failed to install packages");

  unsafe { println!("{}", String::from_utf8_unchecked(install_pkgs.stdout)) };

  print!("\x1B[2J\x1B[1;1H");
  println!("Finished installing packages");

  let motherboard = Command::new("lscpu")
    .output()
    .expect("Failed to get cpu info");
  let motherboard_str = String::from_utf8(motherboard.stdout).expect("Failed to convert to string");

  if motherboard_str.contains("Intel") {
    let driver_list =
      fs::read_to_string("packages/intel-drivers.txt").expect("Failed to open intel driver file");
    let install = Command::new("sudo")
      .args(["pacman", "-S"])
      .args(driver_list.split_whitespace())
      .stdin(Stdio::piped())
      .stdout(Stdio::piped())
      .spawn()
      .expect("Failed to install intel drivers");
    let install = install.wait_with_output().expect("Something went wrong");

    unsafe { println!("{}", String::from_utf8_unchecked(install.stdout)) };
  } else if motherboard_str.contains("AMD") {
    let driver_list =
      fs::read_to_string("packages/amd-drivers.txt").expect("Failed to open amd driver file");
    let install = Command::new("sudo")
      .args(["pacman", "-S"])
      .args(driver_list.split_whitespace())
      .stdin(Stdio::piped())
      .stdout(Stdio::piped())
      .spawn()
      .expect("Failed to install amd drivers");
    let install = install.wait_with_output().expect("Something went wrong");

    unsafe { println!("{}", String::from_utf8_unchecked(install.stdout)) };
  } else {
    eprintln!("Couldn't get cpu info");
  }

  println!("\nDone!");
}
