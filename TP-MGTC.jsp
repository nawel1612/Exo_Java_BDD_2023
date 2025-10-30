<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.time.LocalDate, java.time.format.DateTimeFormatter" %> // liste utils

<%!
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

        public String getTitre() {
            return titre; 
        }

        public String getDescription() { 
            return description; 
        }

        public LocalDate getDateEcheance() {
            return dateEcheance;
        }

        public boolean isTerminee() {
            return terminee;
        }

        // Ton Setter (parfait)
        public void setTerminee(boolean t) {
            terminee = t;
        }
    }

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<% 
    HttpSession sessionHttp = request.getSession();
    @SuppressWarnings("unchecked")
    List<Task> taksList = (List<Task>) sessionHttp.getAttribute("taskList");
    if (taskList == null) {
        taskList = new ArrayList<>(); 
        sessionHttp.SetAttribute("taskList", taskList);
    }

    String action = request.getParameter("action");
    boolean listModified = false; 

    try  {
            if (acrtion !=null)  {

                if (action.equals("add") && request.getMethod().equals("Post"))  {
                    String titre = request.getParameter("titre");
                    String description = request.getParameter("description");
                    String dateStr = request.getParameter("dateEcheance");
                
                    LocalDate dateEcheance = null;
                    if (dateStr != null && !dateStr.isEmpty()) {
                        dateEcheance = LocalDate.parse(dateStr);
                    }
                
                    taskList.add(new Task(titre, description, dateEcheance));
                    listModified = true;
                }
            }
            else if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id")); 
                if (id >= 0 && id < taskList.size()) { 
                    task.List.remove(id);
                    listModified = true;
                    }
                }
            else if (action.equals("complete")) {
                int id = Integer.parseInt(request.getParameter("id")); 
                if (id >= 0 && id < taskList.size()) { 
                    task.List.get(id).setTerminee(true);
                    listModified = true;
                    }
                }
    } catch (Exception e) { 
    }

    if (listModified) { 
        sessionHttp.setAttribute("taskList", taskList);
        reponse.sendRedirect("TP-MGTC.jsp");
        return; 
    }
%>



