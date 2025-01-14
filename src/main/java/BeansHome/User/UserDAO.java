//#################################################################################################
//UserDAO.java - 사용자 DAO 모듈
//#################################################################################################
//═════════════════════════════════════════════════════════════════════════════════════════
//외부모듈 영역
//═════════════════════════════════════════════════════════════════════════════════════════
package BeansHome.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Common.ExceptionMgr;
import DAO.DBOracleMgr;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.io.StringWriter;
import java.io.PrintWriter;
import oracle.jdbc.OracleTypes;
import java.sql.Types;

//═════════════════════════════════════════════════════════════════════════════════════════
//사용자정의 클래스 영역
//═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
* UserDAO    : 사용자 DAO 클래스<br>
* Inheritance : None
***********************************************************************/
public class UserDAO {
    // —————————————————————————————————————————————————————————————————————————————————————
    // 전역상수 관리 - 필수영역
    // —————————————————————————————————————————————————————————————————————————————————————
    private static final DBOracleMgr db = new DBOracleMgr();
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());
    
    // —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
    // —————————————————————————————————————————————————————————————————————————————————————
    /***********************************************************************
    * UserDAO()    : 생성자
    * @param void  : None
    ***********************************************************************/
    public UserDAO() {
        try {
            ExceptionMgr.SetMode(ExceptionMgr.RUN_MODE.DEBUG);
        } catch (Exception Ex) {
            ExceptionMgr.DisplayException(Ex);
        }
    }

    // —————————————————————————————————————————————————————————————————————————————————————
    // 전역함수 관리 - 필수영역(인스턴스함수)
    // —————————————————————————————————————————————————————————————————————————————————————
    /***********************************************************************
    * getUserById()    : 사용자 정보 조회
    * @param userId    : 사용자 ID
    * @return UserDTO  : 사용자 정보 DTO
    * @throws Exception
    ***********************************************************************/
    public UserDTO getUserById(int userId) throws Exception {
        UserDTO user = null;
        String sql = "SELECT * FROM TB_USER WHERE USER_ID = ?";
        Object[] params = new Object[]{userId};
        
        try {
            logger.info("Attempting to get user by ID: " + userId);
            if (db.RunQuery(sql, params, 0, true)) { // 0은 OUT parameter가 없음을 의미, true는 SELECT 쿼리임을 의미
                ResultSet rs = db.Rs;
                if (rs.next()) {
                    user = new UserDTO();
                    user.setUserId(rs.getInt("USER_ID"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setName(rs.getString("NAME"));
                    user.setNickname(rs.getString("NICKNAME"));
                    user.setIntro(rs.getString("INTRO"));
                    user.setStudyDate(rs.getDate("STUDY_DATE"));
                    // Timestamp를 int로 변환 (초 단위로)
                    Timestamp ts = rs.getTimestamp("STUDY_TIME");
                    user.setStudyTime(ts != null ? (int)(ts.getTime() / 1000) : 0);
                    user.setStudyDay(rs.getInt("STUDY_DAY"));
                    user.setQuizCount(rs.getInt("QUIZ_COUNT"));
                    user.setQuizRight(rs.getInt("QUIZ_RIGHT"));
                    user.setPoint(rs.getInt("POINT"));
                    logger.info("User found: " + user.getNickname());
                } else {
                    logger.warning("No user found with ID: " + userId);
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting user by ID: " + userId, e);
            throw e;
        }
        
        return user;
    }

    /***********************************************************************
    * updateUserStats()    : 사용자 통계 정보 업데이트
    * @param user          : 사용자 DTO
    * @return boolean      : 업데이트 성공 여부
    * @throws Exception
    ***********************************************************************/
    public boolean updateUserStats(UserDTO user) throws Exception {
        String sql = "UPDATE TB_USER SET STUDY_DAY = ?, QUIZ_COUNT = ?, QUIZ_RIGHT = ?, POINT = ? WHERE USER_ID = ?";
        Object[] params = new Object[]{
            user.getStudyDay(),
            user.getQuizCount(),
            user.getQuizRight(),
            user.getPoint(),
            user.getUserId()
        };
        
        try {
            return db.RunQuery(sql, params, 0, false); // false는 UPDATE 쿼리임을 의미
        } catch (Exception e) {
            logger.severe("Error updating user stats: " + e.getMessage());
            throw e;
        }
    }

    /***********************************************************************
    * login()         : 로그인 처리
    * @param email    : 사용자 이메일
    * @param password : 사용자 비밀번호
    * @return UserDTO : 로그인 성공시 사용자 정보, 실패시 null
    ***********************************************************************/
    public UserDTO login(String email, String password) throws Exception {
        UserDTO user = null;
        String sql = "BEGIN SP_USER_LOGIN(?, ?, ?); END;";
        Object[] params = new Object[]{email, password};
        
        try {
            if (db.RunQuery(sql, params, 3, true)) { // 3은 세 번째 파라미터가 OUT cursor임을 의미
                ResultSet rs = db.Rs;
                if (rs.next()) {
                    String storedPassword = rs.getString("PASSWORD");
                    if (password.equals(storedPassword)) {
                        user = new UserDTO();
                        user.setUserId(rs.getInt("USER_ID"));
                        user.setEmail(rs.getString("EMAIL"));
                        user.setName(rs.getString("NAME"));
                        user.setNickname(rs.getString("NICKNAME"));
                        user.setIntro(rs.getString("INTRO"));
                        user.setStudyDate(rs.getDate("STUDY_DATE"));
                        user.setStudyTime(rs.getInt("STUDY_TIME"));
                        user.setStudyDay(rs.getInt("STUDY_DAY"));
                        user.setQuizCount(rs.getInt("QUIZ_COUNT"));
                        user.setQuizRight(rs.getInt("QUIZ_RIGHT"));
                        user.setPoint(rs.getInt("POINT"));
                        
                        logger.info("Login successful for user: " + user.getEmail());
                    }
                }
            }
        } catch (Exception e) {
            logger.severe("Error during login: " + e.getMessage());
            throw e;
        }
        
        return user;
    }

    /***********************************************************************
    * register()      : 회원가입 처리
    * @param user     : 등록할 사용자 정보
    * @return boolean : 등록 성공 여부
    ***********************************************************************/
    public boolean register(UserDTO user) throws Exception {
        String sql = "{call SP_USER_REGISTER(?, ?, ?, ?, ?)}";
        Object[] params = new Object[]{
            user.getEmail(),
            user.getPassword(),
            user.getName(),
            user.getNickname()
        };
        
        try {
            return db.RunQuery(sql, params, 5, false); // 5는 다섯 번째 파라미터가 OUT parameter임을 의미
        } catch (Exception e) {
            logger.severe("Error during registration: " + e.getMessage());
            throw e;
        }
    }
}
//#################################################################################################
//<END>
//################################################################################################# 