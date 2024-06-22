package main

import (
	"log"
	"os"
	"os/exec"
	"syscall"
)

func main() {
    log.SetFlags(0) // no timestamps on our logs

    if len(os.Args) < 2 {
        log.Fatalf("error: unable to determinate frp program")
        os.Exit(1)
    }

    cmd := os.Args[1]
    program := string(append([]byte("frp"), cmd[len(cmd) - 1]))

    iniFile := "/etc/" + program + ".ini"
    if _, err := os.Stat(iniFile); err == nil {
        tomlFile := "/etc/" + program + ".toml"
        for i := 0; i < len(os.Args); i++ {
            if os.Args[i] == tomlFile {
                log.Printf("[WARN] INI configuration is deprecated and will be removed in future releases")
                os.Args[i] = iniFile
                break
            }
        }
    }

    path, err := exec.LookPath(cmd)
    if err != nil {
        log.Fatalf("error: %v", err)
    }

    if err = syscall.Exec(path, os.Args[1:], os.Environ()); err != nil {
        log.Fatalf("error: exec failed: %v", err)
    }
}
