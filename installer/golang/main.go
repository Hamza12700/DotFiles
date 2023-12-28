package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/fatih/color"
)

const yayGit string = "git clone https://aur.archlinux.org/yay.git"

func main() {

	cmd := exec.Command("clear")
	cmd.Stdout = os.Stdout
	cmd.Run()

	color.Cyan("Golang installer!\n\n")

	color.Green("Checking the AUR Helper")
	if isCommandAvailable("yay") {
		successPrint("yay AUR Helper found")
	} else {
		errorPrint("yay AUR Helper not found")
		color.Yellow("Install it? [y/n]")
		var yes string
		fmt.Scanln(&yes)

		if yes == "y" {
			yayInstall()
		}
	}

	if isCommandAvailable("stow") {
		successPrint("stow command found!")
		linkConfigDirs()
	} else {
		errorPrint("stow command not found")
		requiredPkgInstaller("stow")
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
		errorPrint("Didn't install the package!")
		os.Exit(1)
	}
}

func linkConfigDirs() {
	currDur, _ := os.Getwd()
	exec.Command("cd", "../../config/").Run()
	link := exec.Command("stow", "*/", "-t", "~/")
	linkErr := link.Run()
	if linkErr != nil {
		errorPrint("Something went wrong while linking the config dirs!")
		log.Fatal(linkErr)
	}
	successPrint("Successfully link the config dirs")
	exec.Command("cd", currDur)
}

