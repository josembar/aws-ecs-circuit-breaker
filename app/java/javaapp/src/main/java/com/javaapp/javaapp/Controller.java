package com.javaapp.javaapp;

import java.util.Collections;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

	@GetMapping(path = "/", produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> getRoot() {
    	return ResponseEntity.status(HttpStatus.OK).body(
            	Collections.singletonMap("message", "ok"));
	}

	@GetMapping(path = "/hello", produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Object> getHello() {
    	return ResponseEntity.status(HttpStatus.OK).body(
            	Collections.singletonMap("message", "hello"));
	}
}