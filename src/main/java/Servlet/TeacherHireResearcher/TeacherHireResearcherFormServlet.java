package Servlet.TeacherHireResearcher;

import Service.TeacherHireResearcher.TeacherHireResearcherFormService;
import Servlet.login.ServletEntryPoint;
import fr.opensagres.xdocreport.document.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class TeacherHireResearcherFormServlet extends ServletEntryPoint {

    private TeacherHireResearcherFormService teacherHireResearcherFormService = new TeacherHireResearcherFormService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        req.setCharacterEncoding("UTF-8");
        req.setAttribute("json", teacherHireResearcherFormService.get(Integer.parseInt((String) session.getAttribute("projectId"))));

        String userRole = session.getAttribute("userRole").toString();
        req.setAttribute("role", userRole);

        req.getRequestDispatcher("WEB-INF/jsp/TeacherHireResearcher/TeacherHireResearcherForm.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        JSONObject json = new JSONObject(readJSONString(req));
        String userRole = session.getAttribute("userRole").toString();
        switch (userRole) {
            case "teacher":
                teacherHireResearcherFormService.save(json, Integer.parseInt((String) session.getAttribute("projectId")));
                break;
            case "department":
                teacherHireResearcherFormService.updateDepartmentReviewData(json, Integer.parseInt((String) session.getAttribute("projectId")));
                break;
            case "college":
                teacherHireResearcherFormService.updateCollegeReviewData(json, Integer.parseInt((String) session.getAttribute("projectId")));
                break;
            case "researchAndDevelopmentOffice":
                teacherHireResearcherFormService.updateRADOReviewData(json, Integer.parseInt((String) session.getAttribute("projectId")));
                break;
        }

        resp.sendRedirect("TeacherHireResearcherCatalog");
    }
}
