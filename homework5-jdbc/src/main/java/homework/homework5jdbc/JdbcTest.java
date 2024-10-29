package homework.homework5jdbc;
import java.sql.*;



public class JdbcTest {
    String url = "jdbc:mysql://localhost:3306/javaweb";
    String user = "root";
    String password = "111111";
    String instersql = "INSERT INTO teacher (id,name,course,birthday) VALUES (?,?,?,?)";
    String deletesql = "delete from teacher where id = ?";
    String slectsql = "SELECT * FROM student WHERE id = ?";
    String updatesql = "UPDATE student SET name = ? WHERE id = ?";

    public void insert() {
        try (Connection conn = DriverManager.getConnection(url, user, password);) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(instersql);) {
                // 设置参数
                ps.setInt(1, 1);
                ps.setString(2, "诸葛清");
                ps.setString(3, "男");
                ps.setDate(4, new java.sql.Date(System.currentTimeMillis()));
                // 执行插入
                ps.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete() {

        try (Connection conn = DriverManager.getConnection(url, user, password);) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(deletesql);) {
                // 设置参数
                ps.setString(1, "王也");
                // 执行删除
                ps.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update() {
        try (Connection conn = DriverManager.getConnection(url, user, password);) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(updatesql);) {
                // 设置参数
                ps.setString(1, "宝儿姐");
                ps.setInt(2, 2);
                // 执行插入或更新
                ps.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
   public void select() {
       try (Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement ps = conn.prepareStatement(slectsql);
       ) {
           // 设置参数
           ps.setInt(1, 1);
           // 执行查询
           try (ResultSet rs = ps.executeQuery()) {
               // 输出查询结果
               while (rs.next()) {
                   System.out.println(rs.getObject(1) + " " + rs.getObject(2) + " " + rs.getObject(3)+ " " + rs.getObject(4));
               }
           }catch (SQLException e) {
               e.printStackTrace();
           }
       } catch (SQLException e) {
           e.printStackTrace();
       }
   }
   public void BatchInsert(){
       try (Connection conn = DriverManager.getConnection(url, user, password);) {
           conn.setAutoCommit(false);
           try (PreparedStatement ps = conn.prepareStatement(instersql);) {
               // 设置参数
               for (int i = 0; i < 10; i++) {
                   ps.setInt(1,i);
                   ps.setString(2, "name"+i);
                   ps.setString(3, i % 2 == 0 ? "语文" : "数学");
                   ps.setDate(4, new java.sql.Date(System.currentTimeMillis()));
                   // 添加到批处理
                   ps.addBatch();
                   if (i % 5 == 0) { // 每5条记录执行一次批处理
                       ps.executeBatch();
                       ps.clearBatch();
                   }
               }
               ps.executeBatch();
               conn.commit();
               System.out.println("完成批量插入数据");
           } catch (SQLException e) {
               conn.rollback();
               e.printStackTrace();
           }
       } catch (SQLException e) {
           e.printStackTrace();
       }
   }
   public void RollingSet(){
       try (Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement ps = conn.prepareStatement(slectsql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
       ) {
           // 设置参数
           ps.setInt(1, 20);
           // 执行查询
           try (ResultSet rs = ps.executeQuery()) {

               // 移动到倒数第二行
               rs.absolute(-2);
               System.out.println(rs.getInt("id") + " " + rs.getString("name"));


           }catch (SQLException e) {
               e.printStackTrace();
           }

       } catch (SQLException e) {
           e.printStackTrace();
       }
   }
}