package main

import "fmt"

func main() {
	var nums []int
	for i := 1; i <= 100; i++ {
		if i%3 == 0 {
			nums = append(nums, i)
		}
	}

	fmt.Print("Числа, кратные 3 в диапазоне 1-100: ", nums, "\n")
}
