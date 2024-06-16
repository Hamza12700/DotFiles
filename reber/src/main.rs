use clap::Parser;
use colored::*;
use std::{
  fs,
  path::{Path, PathBuf},
  process::{self, Command, Stdio},
};
use toml::Table;

/// Simple porgram to install packages from a toml config file
#[derive(Debug, Parser)]
#[command(version, about, long_about = None)]
struct Args {
  /// Name of the toml file
  #[arg(short, long)]
  file: Option<PathBuf>,
}

fn main() {
  let args = Args::parse();

  if let Some(file_path) = args.file {
    let file = fs::read_to_string(file_path).expect("Failed to read file");
    proceed_installation(file);
  } else if Path::new(".reber").is_dir() {
    if !fs::metadata(".reber/config.toml").is_ok() {
      eprintln!(
        "{}",
        "config.toml file wasn't found in .reber directory".red()
      );
      process::exit(1);
    }
    let config_file = fs::read_to_string(".reber/config.toml").unwrap();
    proceed_installation(config_file);
  } else {
    eprintln!("{}", "Didn't found .reber diectory".red());
    eprintln!(
      "{}",
      "You could specific the path for the toml config file by using -f flag".yellow()
    );
    process::exit(1);
  }
}

fn proceed_installation(config_file: String) {
  let parsed_toml: Table = config_file.parse().expect("Failed to parse file");
  let pkgs_table = &parsed_toml["packages"];

  if let Some(arch_pkgs) = &pkgs_table
    .get("arch")
    .and_then(|arch_pkgs| arch_pkgs.as_array())
  {
    let pkgs: Vec<&str> = arch_pkgs.iter().filter_map(|pkg| pkg.as_str()).collect();
    let arch_aur_helper = pkgs_table
      .get("aur_helper")
      .and_then(|aur_helper| aur_helper.as_str());

    let install_args = pkgs_table
      .get("install_args")
      .and_then(|args| args.as_array());
    if install_args.is_none() {
      eprintln!("{}", "Install arguments wasn't found".red());
      eprintln!("{}", "+ install_args = [\"-Syu\"]".green());
      process::exit(1);
    }
    let install_args = install_args.unwrap();
    let install_args: Vec<&str> = install_args
      .iter()
      .filter_map(|args| args.as_str())
      .collect();

    if arch_aur_helper.is_none() {
      eprintln!(
        "{}",
        "Didn't find what aur helper to use to install the packages".red()
      );
      eprintln!("{}", "+ aur_helper = \"paru\"".green());
      process::exit(1);
    }
    let aur_helper = arch_aur_helper.unwrap();
    let mut install_pkgs = Command::new(aur_helper)
      .args(install_args)
      .args(pkgs)
      .stdout(Stdio::inherit())
      .stdin(Stdio::inherit())
      .stderr(Stdio::inherit())
      .spawn()
      .unwrap();

    let exit_code = install_pkgs.wait().unwrap();
    if !exit_code.success() {
      eprintln!("{}", "The process didn't not exit successfully".yellow());
    }
  }
}
