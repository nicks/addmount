package main

import (
	"net/http"
	"os/exec"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.SetTrustedProxies(nil)
	r.GET("/addmount", func(c *gin.Context) {
		src := c.Query("src")
		srcProc := c.Query("src-proc")
		dest := c.Query("dest")
		destProc := c.Query("dest-proc")
		if src == "" || srcProc == "" || dest == "" || destProc == "" {
			c.String(http.StatusBadRequest,
				"Malformed request. Example: /addmount?src=/tmp&src-proc=src-container-name&dest=/tmp&dest-proc=dest-container-name")
			return
		}

		cmd := exec.Command("/usr/local/bin/add-mount-helper.sh", srcProc, src, destProc, dest)
		err := cmd.Run()
		if err != nil {
			exitErr, ok := err.(*exec.ExitError)
			if ok {
				c.String(http.StatusInternalServerError, "Error: %v\nStderr: %s\n", exitErr, string(exitErr.Stderr))
				return
			}
			c.String(http.StatusInternalServerError, "Error: %v", err)
			return
		}

		c.String(http.StatusOK, "OK")
	})
	r.Run()
}
