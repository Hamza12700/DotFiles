package main

import (
	"fmt"
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
		color.Cyan("'yay' AUR Helper Found!")
	} else {
		color.Red("'yay' Aur Helper not found!")
		color.Yellow("Install it? [y/n]")
		var yes string
		fmt.Scanln(&yes)

		if yes == "y" {
			checkCmd := exec.Command("git", "clone", yayGit)
			checkCmd.Stdout = os.Stdout
			checkCmd.Stderr = os.Stderr

			cloneErr := checkCmd.Run()
			if cloneErr != nil {
				color.Red("Error cloning the repo")
				fmt.Print(cloneErr)
				os.Exit(1)
			}

			exec.Command("cd", "yay").Run()
			install := exec.Command("makepkg", "-si")
			install.Stderr = os.Stderr
			install.Stdout = os.Stdout
			install.Stdin = os.Stdin
			installErr := install.Run()
			if installErr != nil {
				color.Red("Something went wrong!")
				fmt.Print(installErr)
			}
		}
	}

}

func isCommandAvailable(commandName string) bool {
	color.Green("Checking if '%s' command exist", commandName)
	cmd := exec.Command("/bin/sh", "-c", "command -v "+commandName)
	if err := cmd.Run(); err != nil {
		return false
	}
	return true
}
