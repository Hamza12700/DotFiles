package main

import (
	"fmt"
	"io"
	"log"
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

	// Updating the system

	successPrint("Updating the system")
	sysCommand("yay", "-Syu")

	file, fileErr := os.Open("packages.txt")
	if fileErr != nil {
		log.Fatal(fileErr)
	}

	buffer := make([]byte, 1024)
	for {
		n, err := file.Read(buffer)
		if err == io.EOF {
			break
		}

		if err != nil {
			fmt.Println(err)
			continue
		}

		pkgs := string(buffer[:n])

		if n > 0 {
			fmt.Println(pkgs)
		}

		sysCommand("yay", "-S", pkgs, "--needed", "--noconfirm")
	}

	file.Close()
	
}
