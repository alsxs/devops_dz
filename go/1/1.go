package main

import "fmt"

func main() {
	fmt.Print("Введите длину в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input * 3.2808

	fmt.Print("В футах эта длина составит: ", output, "\n")
}
