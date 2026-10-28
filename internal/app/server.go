package app

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	if _, err := fmt.Fprint(w, "Hello World"); err != nil {
		log.Printf("writing response: %v", err)
	}
}

func RunServer() {
	http.HandleFunc("/", handler)
	log.Println("Starting server on :8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
