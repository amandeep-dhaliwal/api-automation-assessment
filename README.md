# API Automation Assessment - Robot Framework

## Overview

This project contains automated API tests for the JSONPlaceholder REST API.

The automation is implemented using Robot Framework and RequestsLibrary. The test suite covers positive and negative API scenarios and generates Robot Framework execution reports.

## Base URL

https://jsonplaceholder.typicode.com

## Technologies Used

- Robot Framework 
- RequestsLibrary
- Python

## Automated Test Coverage

The suite covers:

- GET /posts
- GET /posts/{id}
- POST /posts
- PUT /posts/{id}
- PATCH /posts/{id}
- DELETE /posts/{id} 
- GET /users
- GET /comments?postId={id}
- Invalid resource ID
- Invalid endpoint
- Missing required payload
- Unexpected input

The tests validate HTTP status codes, response content, required fields, data types, and expected API behavior.

## Project Structure

api_tests.robot - Robot Framework API test suite

requirements.txt - Project dependencies 
README.md - Setup and execution documentation

report.html - Robot Framework execution report

log.html - Detailed Robot Framework execution log

output.xml - Robot Framework machine-readable results 
## Installation

Install the required dependencies:

pip install -r requirements.txt

## Running the Tests

Run the complete test suite using:

robot api_tests.robot

Robot Framework generates the following execution artifacts:

- report.html 
- log.html
- output.xml

## API Behavior Observation

JSONPlaceholder is a fake REST API and simulates write operations.

During negative testing, the API accepted an incomplete POST payload and returned HTTP 201 even though the supplied API specification defines title, body, and userId as required fields. 
The API also accepted and echoed an unexpected field in the POST payload.

These scenarios are included in the automated suite to document the actual behavior of the test API.

## Maintainability

The suite uses a centralized base URL and readable Robot Framework test cases. For a larger production framework, common API operations, test data, environment configuration, authentication, and reusable validation keywords would be separated into resource and configuration files.

## Reporting 
Robot Framework automatically generates HTML execution reports and detailed logs after each test run.
