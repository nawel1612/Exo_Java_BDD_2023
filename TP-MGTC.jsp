<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.time.LocalDate, java.time.format.DateTimeFormatter" %>

<%!
    public class Task {
        private String titre;
        private String description;
        private LocalDate dateEcheance;
        private boolean terminee;

        // Ton constructeur (parfait)
        public Task(String t, String d, LocalDate de) {
            titre = t;
            description = d;
            dateEcheance = de;
            terminee = false;
        }

        // Tes Getters (corrigés)
        public String getTitre() {
            return titre; // Corrigé
        }

        public String getDescription() { // Corrigé
            return description; // Corrigé
        }

        public LocalDate getDateEcheance() {
            return dateEcheance; // Corrigé
        }

        public boolean isTerminee() {
            return terminee;
        }

        // Ton Setter (parfait)
        public void setTerminee(boolean t) {
            terminee = t;
        }
    }

    // Ton Formatter (parfait)
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>


<%-- 
========================================================================
    PARTIE 2 : SCRIPTLET (Le Contrôleur)
    Cette partie reste identique, elle fonctionne avec ta classe.
========================================================================
--%>
<%
    // 1. Récupérer la session HTTP
    HttpSession sessionHttp = request.getSession();

    // 2. Récupérer (ou créer) la liste de tâches en session
    @SuppressWarnings("unchecked")
    List<Task> taskList = (List<Task>) sessionHttp.getAttribute("taskList");
    if (taskList == null) {
        taskList = new ArrayList<>();
        sessionHttp.setAttribute("taskList", taskList);
    }

    // 3. Traiter les actions (Ajout, Suppression, Complétion)
    String action = request.getParameter("action");
    boolean listModified = false; // Pour savoir si on doit rediriger

    try {
        if (action != null) {
            
            // --- ACTION : AJOUTER ---
            if (action.equals("add") && request.getMethod().equals("POST")) {
                String titre = request.getParameter("titre");
                String description = request.getParameter("description");
                String dateStr = request.getParameter("dateEcheance");
                
                LocalDate dateEcheance = null;
                if (dateStr != null && !dateStr.isEmpty()) {
                    dateEcheance = LocalDate.parse(dateStr);
                }
                
                // Appel de ton constructeur (new Task(String, String, LocalDate))
                taskList.add(new Task(titre, description, dateEcheance));
                listModified = true;

            // --- ACTION : SUPPRIMER ---
            } else if (action.equals("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id >= 0 && id < taskList.size()) {
                    taskList.remove(id); 
                    listModified = true;
                }

            // --- ACTION : TERMINER ---
            } else if (action.equals("complete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id >= 0 && id < taskList.size()) {
                    // Appel de ton setter (setTerminee(boolean))
                    taskList.get(id).setTerminee(true); 
                    listModified = true;
                }
            }
        }
    } catch (Exception e) {
        // Gère silencieusement les erreurs
    }

    // 4. Redirection (Post-Redirect-Get)
    if (listModified) {
        sessionHttp.setAttribute("taskList", taskList);
        response.sendRedirect("TP-MGDT.jsp");
        return; // TRÈS IMPORTANT
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

    <h1>📝 Mini Gestionnaire de Tâches Collaboratif</h1>

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
            <label for="dateEcheance">Date d'échéance :</label>
            <input type="date" id="dateEcheance" name="dateEcheance" required>
        </div>
        <button type="submit">Ajouter la Tâche</button>
    </form>

    <hr style="margin: 30px 0;">

    <h2>📋 Liste des Tâches</h2>

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
                            <%= (tache.getDateEcheance() != null) ? tache.getDateEcheance().format(formatter) : "N/A" %>
                        </td>
                        <td>
                            <%= tache.isTerminee() ? "Terminée" : "En cours" %>
                        </td>
                        <td class="action-links">
                            <% if (!tache.isTerminee()) { %>
                                <a href="TP-MGDT.jsp?action=complete&id=<%= i %>" class="complete">✅ Terminer</a>
                            <% } %>
                            
                            <a href="TP-MGDT.jsp?action=delete&id=<%= i %>" 
                               class="delete"
                               onclick="return confirm('Voulez-vous vraiment supprimer cette tâche ?');">
                                ❌ Supprimer
                            </a>
                        </td>
                    </tr>
                <% 
                   } // Fin de la boucle for
                %>
            </tbody>
        </table>
    <% 
        } else { 
    %>
        <p>Aucune tâche n'a été ajoutée pour le moment.</p>
    <% 
        } // Fin du if
    %>

</body>
</html>
