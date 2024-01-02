package main

import (
	"bufio"
	"log"
	"os"
	"os/exec"
	"strings"

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

	// Installing packages

	file, fileErr := os.Open("../../README.md")
	if fileErr != nil {
		log.Fatal(fileErr)
	}

	scanner := bufio.NewScanner(file)
	pkgsFound := false

	for scanner.Scan() {
		line := scanner.Text()

		if strings.Contains(line, "yay") {
			pkgsFound = true
		}

		if pkgsFound {
			sysCommand(line)
		}

		if strings.Contains(line, "--needed") {
			pkgsFound = false
			break
		}
	}

	if readErr := scanner.Err(); readErr != nil {
		log.Fatalln(readErr)
	}
	file.Close()
	
	// Enabling systemD services

	services := []string{ "bluetooth", "ly" }	
	for _, service := range services {
		systemDServiceActivate(service)
	}

}
