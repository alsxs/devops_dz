package main

import "fmt"

var x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

func main() {
	fmt.Println(x)
	minx := x[0]
	for i := 1; i < len(x); i++ {
		if minx > x[i] {
			minx = x[i]
		}
	}
	fmt.Print("Наименьшее число в массиве: ", minx, "\n")
}
