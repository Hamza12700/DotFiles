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

	clear := exec.Command("clear")
	clear.Stdout = os.Stdout
	clear.Run()

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
		readBytes, readErr := file.Read(buffer)
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
	
	// Enabling systemD services

	services := []string{ "bluetooth", "ly" }	
	for _, service := range services {
		systemDServiceActivate(service)
	}

}
