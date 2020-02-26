package test

import (
	"fmt"
	"strings"

	"github.com/gruntwork-io/terratest/modules/random"
)

func getUniqueTestZoneName() string {
	return strings.ToLower(fmt.Sprintf("mineiros-%s.io", random.UniqueId()))
}
