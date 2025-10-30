<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.time.LocalDate, java.time.format.DateTimeFormatter" %> // liste utils

<% 
public class Task { 
  private String titre;
  private String description;
  private LocalDate dateEcheance; 
  private boolean terminee; 

  public Task(String t, String d, LocalDate de) {
    titre = t;
    description = d;
    dateEcheance = de;
    terminee = false;
  }
  public String getTitre(){
    return Titre;
  }
  public String getdescription() {
    return Description;
  }
  public LocalDate getDateEcheance() {
    return DateEcheance;
  }
  public boolean isTerminee() { 
    return terminee; 
  }
  public void setTerminee(boolean t) {
      terminee = t;
        }
  }
 private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>



