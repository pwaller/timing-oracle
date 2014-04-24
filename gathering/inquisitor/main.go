// Try to find a secret through a string comparison timing attack

package main

import (
	// "os"
	// "rand"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

func TimeCompare(query string) time.Duration {
	start := time.Now()

	// if a == b {
	// 	log.Println("Password cracked")
	// 	os.Exit(0)
	// }
	res, err := http.Get("http://localhost:3000/crack/" + query)
	if err != nil {
		panic(err)
	}

	if res.StatusCode == 200 {
		log.Println("Password cracked!")
	}

	return time.Since(start)
}

func main() {

	answer := strings.Repeat("z", 1)

	for i := 0; i < 1000; i++ {
		dur := TimeCompare(answer) //answer[:63] + "y")
		// println(int(dur))
		fmt.Printf("%d\n", int(dur))
	}

}
