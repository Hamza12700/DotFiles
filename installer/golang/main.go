package main

import (
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
	isCommandAvailable("yay")

	isCommandAvailable("stow")
	linkConfigDirs()
}
