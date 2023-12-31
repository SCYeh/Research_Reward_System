package Servlet.SunshineScholarshipAward;


import Service.Admin.AwardTimeLimitService;
import Service.SunshineScholarshipAward.GeneralInformationService;
import Servlet.login.ServletEntryPoint;
import fr.opensagres.xdocreport.document.json.JSONObject;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;



public class SunshineScholarshipAwardGeneralInformationServlet extends ServletEntryPoint {
    private static final String STAFF_URL_EDIT = "WEB-INF/jsp/SunshineScholarshipAward/edit/GeneralInformationOfStaff.jsp";
    private static final String STAFF_URL_READONLY = "WEB-INF/jsp/SunshineScholarshipAward/readonly/GeneralInformationOfStaff.jsp";
    private static final String LOGIN_URL = "WEB-INF/jsp/login/login.jsp";
    private GeneralInformationService generalInformationService= new GeneralInformationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AwardTimeLimitService awardTimeLimitService = new AwardTimeLimitService();

        HttpSession session = req.getSession();
        //userRole has been stored in session when login
        boolean readonly = (Boolean)session.getAttribute("readonly");
        req.setCharacterEncoding("UTF-8");
        // 共用fwci of ntut
        req.setAttribute("fwci", awardTimeLimitService.get().getDouble("fwciOfFiveYear"));
        req.setAttribute("h5Index", awardTimeLimitService.get().getDouble("h5Index"));
        req.setAttribute("json",generalInformationService.get(Integer.valueOf((String)session.getAttribute("projectId"))));

        if(readonly){
            req.getRequestDispatcher(STAFF_URL_READONLY).forward(req,resp);
        }
        else{
//            req.getRequestDispatcher(STAFF_URL_READONLY).forward(req,resp);
            req.getRequestDispatcher(STAFF_URL_EDIT).forward(req,resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        JSONObject json = new JSONObject(readJSONString(req));
        int projectId = turnIdInSessionToInt(session, "projectId");
        generalInformationService.save(json,projectId);

    }
    private int turnIdInSessionToInt(HttpSession session, String id){
        return Integer.parseInt(session.getAttribute(id).toString());
    }
}
