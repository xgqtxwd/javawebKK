package homework.homework5jdbc;

public class JdbcService {
    public static void main(String[] args) {
        JdbcTest jdbcTest = new JdbcTest();
        jdbcTest.insert();
        jdbcTest.select();
        jdbcTest.update();
        jdbcTest.delete();
    }

}
