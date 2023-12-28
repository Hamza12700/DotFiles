package main

import (
	"log"
	"os"
	"os/exec"

	"github.com/fatih/color"
)

func isCommandAvailable(commandName string) bool {
	color.Green("Checking if '%s' command exist", commandName)
	cmd := exec.Command("/bin/sh", "-c", "command -v "+commandName)
	if err := cmd.Run(); err != nil {
		return false
	}
	return true
}

func yayInstall() {
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

func successPrint(chars string) {
	color.Cyan("\n\n%s\n\n", chars)
}

func errorPrint(chars string) {
	color.Red("\n\n%s\n\n", chars)
}


