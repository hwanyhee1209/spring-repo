package org.ict.springapp.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class IndexController {
  @GetMapping("/")
  public Map<String,String> index() {
    Map<String,String> map = Map.of("message","Hello World! Spring Boot Application");
    return map;
  }
}
