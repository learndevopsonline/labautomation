package main

import "fmt"
import "net/http"

func main() {
  resp, err := http.Get("ifconfig.co")
  if err != nil {
    fmt.Println("Problem with Error")
  }
  fmt.Println("Print Ip Address"+ resp)
  defer resp.Body.Close()
}

