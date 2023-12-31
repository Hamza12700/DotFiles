package main

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/fatih/color"
)

func main() {

	cmd := exec.Command("clear")
	cmd.Stdout = os.Stdout
	cmd.Run()

	color.Cyan("Golang installer!\n\n")

	color.Green("Checking the AUR Helper")
	if isCommandAvailable("yay") {
		successPrint("'yay' AUR Helper found")
	} else {
		errorPrint("'yay' AUR Helper not found")
		color.Yellow("Install it? [y/n]")
		var yes string
		fmt.Scanln(&yes)

		if yes == "y" {
			yayInstall()
		} else {
			errorPrint("'yay' AUR Helper isn't installed!")
			os.Exit(1)
		}
	}

	if isCommandAvailable("stow") {
		successPrint("'stow' command found!")
		linkConfigDirs()
	} else {
		errorPrint("'stow' command not found")
		requiredPkgInstaller("stow")
	}
}

