package s3

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTerraformBaseS3(t *testing.T) {
	backendRegion := "us-east-1"
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		BackendConfig: map[string]interface{}{
			"bucket":         "pafable-tfstates-100",
			"key":            "s3/ci-test/terraform.tfstate",
			"region":         backendRegion,
			"encrypt":        "true",
			"dynamodb_table": "terraform-lock",
		},
		Reconfigure: true,
		Upgrade:     true,
		Vars: map[string]interface{}{
			"app_name": "ci-test",
			"region":   backendRegion,
		},
	})

	// destroy resources when test ends successfully or not
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// checks if bucket name is base-infra-1-bucket-test-us-east-1
	outputBucketName := terraform.Output(t, terraformOptions, "bucket_name")
	assert.Equal(t, "ci-test-bucket-test-us-east-1", outputBucketName)

	// checks if region is us-east-1
	outputBucketRegion := terraform.Output(t, terraformOptions, "bucket_region")
	assert.Equal(t, "us-east-1", outputBucketRegion)
}
