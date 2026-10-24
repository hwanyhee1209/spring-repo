package org.ict.springapp.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class IndexController {
  @GetMapping("/")
  public String index() {
    return "Hello World! Spring Boot Application";
  }
}
