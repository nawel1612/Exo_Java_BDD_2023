<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<%!
    public class Task {
        // Attributs privés
        private String titre;
        private String description;
        private LocalDate dateEcheance;
        private boolean terminee;

        // Constructeur
        public Task(String titre, String description, LocalDate dateEcheance) {
            this.titre = titre;
            this.description = description;
            this.dateEcheance = dateEcheance;
            this.terminee = false; // Par défaut, une tâche n'est pas terminée
        }

        // --- Getters ---
        public String getTitre() { return titre; }
        public String getDescription() { return description; }
        public LocalDate getDateEcheance() { return dateEcheance; }
        public boolean isTerminee() { return terminee; }

        // --- Setters ---
        public void setTerminee(boolean terminee) {
            this.terminee = terminee;
        }
    }

    /**
     * Utilitaire pour formater les dates à l'affichage
     */
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>


<%
   
    HttpSession sessionHttp = request.getSession();

    @SuppressWarnings("unchecked")
    List<Task> taskList = (List<Task>) sessionHttp.getAttribute("taskList");
    if (taskList == null) {
        taskList = new ArrayList<>();
        sessionHttp.setAttribute("taskList", taskList);
    }

    String action = request.getParameter("action");
    boolean listModified = false; // Pour savoir si on doit rediriger

    try {
        if (action != null) {
            
            if (action.equals("add") && request.getMethod().equals("POST")) {
                String titre = request.getParameter("titre");
                String description = request.getParameter("description");
                String dateStr = request.getParameter("dateEcheance");
                
                LocalDate dateEcheance = null;
                if (dateStr != null && !dateStr.isEmpty()) {
                    dateEcheance = LocalDate.parse(dateStr);
                }
                
                taskList.add(new Task(titre, description, dateEcheance));
                listModified = true;

            } else if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id >= 0 && id < taskList.size()) {
                    taskList.remove(id); // Suppression de la tâche [cite: 19]
                    listModified = true;
                }

            } else if (action.equals("complete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id >= 0 && id < taskList.size()) {
                    taskList.get(id).setTerminee(true); // Marquer comme terminée [cite: 19]
                    listModified = true;
                }
            }
        }
    } catch (Exception e) {
        // Gère silencieusement les erreurs (ex: ID non numérique)
        // e.printStackTrace(); // Pour le débogage
    }

    if (listModified) {
        sessionHttp.setAttribute("taskList", taskList);
        response.sendRedirect("TP-MGDT.jsp");
        return;
    }

%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mini Gestionnaire de Tâches</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 20px; background-color: #f9f9f9; }
        h1, h2 { color: #333; }
        form { background: #fff; border: 1px solid #ddd; padding: 20px; border-radius: 8px; }
        form div { margin-bottom: 15px; }
        form label { display: block; margin-bottom: 5px; font-weight: bold; }
        form input[type="text"], form textarea, form input[type="date"] { width: 400px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        form textarea { height: 80px; }
        form button { background-color: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; }
        form button:hover { background-color: #0056b3; }
        
        .task-list { border-collapse: collapse; width: 100%; margin-top: 20px; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .task-list th, .task-list td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        .task-list th { background-color: #f2f2f2; }
        .task-list tr:nth-child(even) { background-color: #f9f9f9; }
        
        .task-completed td { text-decoration: line-through; color: #888; }
        .action-links a { margin-right: 10px; text-decoration: none; }
        .action-links .delete { color: #dc3545; }
        .action-links .complete { color: #28a745; }
    </style>
</head>
<body>

    <h1>Mini Gestionnaire de Tâches Collaboratif </h1>

    <h2>Ajouter une Tâche</h2>
    
    <form action="TP-MGDT.jsp" method="post">
        <input type="hidden" name="action" value="add">
        
        <div>
            <label for="titre">Titre :</label>
            <input type="text" id="titre" name="titre" required>
        </div>
        <div>
            <label for="description">Description :</label>
            <textarea id="description" name="description" required></textarea>
        </div>
        <div>
            <label for="dateEcheance">Date d'échéance :</label> [cite: 19]
            <input type="date" id="dateEcheance" name="dateEcheance" required>
        </div>
        <button type="submit">Ajouter la Tâche</button>
    </form>

    <hr style="margin: 30px 0;">

    <h2>Liste des Tâches</h2>

    <% 
        if (taskList != null && !taskList.isEmpty()) {
    %>
        <table class="task-list">
            <thead>
                <tr>
                    <th>Titre</th>
                    <th>Description</th>
                    <th>Date d'échéance</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                   for (int i = 0; i < taskList.size(); i++) {
                       Task tache = taskList.get(i);
                       String cssClass = tache.isTerminee() ? "class='task-completed'" : "";
                %>
                    <tr <%= cssClass %>>
                        <td><%= tache.getTitre() %></td>
                        <td><%= tache.getDescription() %></td>
                        <td>
                            <%-- Affiche la date si elle existe, sinon "N/A" --%>
                            <%= (tache.getDateEcheance() != null) ? tache.getDateEcheance().format(formatter) : "N/A" %>
                        </td>
                        <td>
                            <%-- Affiche le statut [cite: 19] --%>
                            <%= tache.isTerminee() ? "Terminée" : "En cours" %>
                        </td>
                        <td class="action-links">
                            <%-- Lien pour marquer comme terminée (si ce n'est pas déjà fait) --%>
                            <% if (!tache.isTerminee()) { %>
                                <a href="TP-MGDT.jsp?action=complete&id=<%= i %>" class="complete"> Accomplie </a>
                            <% } %>
                            
                            <%-- Lien pour la suppression [cite: 19] --%>
                            <a href="TP-MGDT.jsp?action=delete&id=<%= i %>" 
                               class="delete"
                               onclick="return confirm('Voulez-vous vraiment supprimer cette tâche ?');">
                                Supprimer
                            </a>
                        </td>
                    </tr>
                <% 
                   } 
                %>
            </tbody>
        </table>
    <% 
        } else { 
    %>
        <p>Aucune tâche n'a été ajoutée pour le moment.</p>
    <% 
        } 
    %>

</body>
</html>
