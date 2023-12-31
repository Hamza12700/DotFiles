package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/fatih/color"
)

const yayGit string = "git clone https://aur.archlinux.org/yay.git"

func isCommandAvailable(commandName string) bool {
	color.Green("Checking if '%s' command exist", commandName)
	cmd := exec.Command("/bin/sh", "-c", "command -v "+commandName)
	if err := cmd.Run(); err != nil {
		return false
	}
	return true
}

func yayInstall() {

	if !isCommandAvailable("git") {
		errorPrint("'git' command not found!")
		color.Cyan("Would you like to install it? [y/n]")
		var yesOrNo string
		fmt.Scanln(yesOrNo)

		if yesOrNo == "y" {
			gitInstall := exec.Command("sudo pacman -S git")
			gitInstall.Stderr = os.Stderr
			gitInstall.Stdin = os.Stdin
			gitInstall.Stdout = os.Stdout
			gitInstall.Run()
		}

		log.Fatalln("'git' isn't installed!")
	}

	yayInstall := exec.Command("git", "clone", yayGit)
	yayInstall.Stdout = os.Stdout
	yayInstall.Stderr = os.Stderr

	cloneErr := yayInstall.Run()
	if cloneErr != nil {
		errorPrint("Something went wrong while cloning the git repo of yay")
		log.Fatal(cloneErr)
	}

	exec.Command("cd", "yay").Run()
	install := exec.Command("makepkg", "-si")
	install.Stderr = os.Stderr
	install.Stdout = os.Stdout
	install.Stdin = os.Stdin
	installErr := install.Run()
	if installErr != nil {
		errorPrint("Something went wrong installing the yay AUR Helper")
		log.Fatal(installErr)
	}
}

func requiredPkgInstaller(pkg string) {
	pacman := exec.Command("sudo", "pacman", "-S", pkg)
	pacman.Stdout = os.Stdout
	pacman.Stderr = os.Stderr
	pacman.Stdin = os.Stdin
	color.Green("Would you like to install %s [y/n]", pkg)
	var yes string
	fmt.Scanln(&yes)

	if yes == "y" {
		pacman.Run()
	} else {
		errorPrint("Didn't install the required package!")
		os.Exit(1)
	}
}

func successPrint(chars string) {
	color.Cyan("\n\n%s\n\n", chars)
}

func errorPrint(chars string) {
	color.Red("\n\n%s\n\n", chars)
}

func linkConfigDirs() {
	currDur, _ := os.Getwd()
	exec.Command("cd", "../../config/").Run()
	link := exec.Command("stow", "*/", "-t", "~/")
	link.Stderr = os.Stderr
	linkErr := link.Run()
	if linkErr != nil {
		errorPrint("Something went wrong while linking the config dirs!")
		log.Fatal(linkErr)
	}
	successPrint("Successfully link the config dirs")
	exec.Command("cd", currDur).Run()
}
