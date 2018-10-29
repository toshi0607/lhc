package main

import (
	"github.com/aws/aws-lambda-go/events"
	"net/http"
	"testing"
)

func TestHandler(t *testing.T) {
	res, _ := handler(events.APIGatewayProxyRequest{
		HTTPMethod: http.MethodPost,
		Body:       "",
	})

	if res.StatusCode != http.StatusOK {
		t.Errorf("ExitStatus=%d, want %d", res.StatusCode, http.StatusOK)
	}
}