from LoginUI import *
from MainWindow import *
from PyQt5.QtWidgets import QApplication, QMainWindow
import sys

import pymysql

connection = pymysql.connect(host='localhost',
                                      user='root',
                                      password='102201lrs',
                                      db='lab2',
                                      charset='utf8mb4',
                                      cursorclass=pymysql.cursors.DictCursor)

def execute_query(sql_query):
    with connection.cursor() as cursor:
        cursor.execute(sql_query)
        connection.commit()
        return cursor.fetchall()

class LoginWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.ui = Ui_LoginUI()
        self.ui.setupUi(self)
        self.setWindowFlag(QtCore.Qt.FramelessWindowHint)
        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)
        self.shadow = QtWidgets.QGraphicsDropShadowEffect(self)
        self.shadow.setOffset(5, 5)
        self.shadow.setBlurRadius(10)
        self.shadow.setColor(QtCore.Qt.black)
        self.ui.frame.setGraphicsEffect(self.shadow)
        self.ui.frame_login.clicked.connect(lambda: self.ui.StackedWidget.setCurrentIndex(0))
        self.ui.frame_register.clicked.connect(lambda: self.ui.StackedWidget.setCurrentIndex(1))
        self.ui.log_ens.clicked.connect(self.login_in)
        self.ui.reg_ens.clicked.connect(self.register_user)
        self.show()

    def login_in(self):
        account = self.ui.log_un.text()
        pswd = self.ui.log_pw.text()
        # print(account, pswd)
        sql_query = f"select * from Userpeople where Userpeople.Uname='{account}' and Userpeople.Upassword='{pswd}'"
        t=execute_query(sql_query)
        print(t)
        if t:
            self.win = MainWindows()
            self.close()
        else:
            print("Wrong Account or Password")
    def register_user(self):
        account = self.ui.reg_un.text()
        pw1 = self.ui.reg_pw.text()
        pw2 = self.ui.reg_pw_2.text()
        if pw1!=pw2:
            return
        sql_query = f"Insert Into Userpeople(Uname,Upassword) VALUES ('{account}','{pw1}')"
        execute_query(sql_query)
        connection.commit()
        print("success register")

class MainWindows(QMainWindow):
    def __init__(self):
        super().__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.setWindowFlag(QtCore.Qt.FramelessWindowHint)
        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)
        self.shadow = QtWidgets.QGraphicsDropShadowEffect(self)
        self.ui.mainpage.clicked.connect(lambda: self.ui.Mainstacked.setCurrentIndex(0))
        self.ui.find.clicked.connect(lambda: self.ui.Mainstacked.setCurrentIndex(1))
        self.ui.regis.clicked.connect(lambda: self.ui.Mainstacked.setCurrentIndex(2))
        self.ui.course.clicked.connect(lambda: self.ui.Mainstacked.setCurrentIndex(3))
        self.ui.find_course.clicked.connect(lambda: self.ui.Mainstacked.setCurrentIndex(4))

        self.ui.find_archive.clicked.connect(self.find_archive)
        self.ui.get_gpa.clicked.connect(self.get_gpa)
        self.ui.find_award.clicked.connect(self.find_award)
        self.ui.find_archive_r.clicked.connect(self.find_ra)

        self.ui.reg_reg.clicked.connect(self.reg_reg)
        self.ui.reg_change.clicked.connect(self.change_major)

        self.ui.write_upload.clicked.connect(self.write_upload)
        self.ui.write_delete.clicked.connect(self.write_delete)

        self.ui.reward_insert.clicked.connect(self.award_insert)
        self.show()

    def get_gpa(self):
        sid = self.ui.find_input_sid.text()
        sql_query = f"Select calGPA({sid}) "
        t = execute_query(sql_query)
        if t:
            print(t)
            gpa = t[0][f"calGPA({sid})"]
            text = f"The GPA of Student {sid} is {gpa}"
        else:
            text = f"Not Find this Student"
        self.ui.textEdit.setText(text)

    def find_ra(self):
        sid = self.ui.find_input_sid.text()
        archive = self.ui.find_input_archive.text()

        state = ""
        with connection.cursor() as cursor:
            result = cursor.callproc('modify_archive', args=[sid, archive, state])
            connection.commit()
        self.ui.textEdit.setText(state)

    def find_archive(self):
        sid = self.ui.find_input_sid.text()
        sql_query = f"Select archive,Class_id,major From Student Where student.student_id = {sid}"
        t = execute_query(sql_query)
        if t:
            text = "Class_id = " + str(t[0]["Class_id"])
            text = text + "\n" + "Major = " +  t[0]["major"] + "\n" + "\n"
            dir = t[0]["archive"]
            with open(dir, 'r', encoding='utf-8') as file:
                c_ = file.read()
            text = text + "archive:\n" + c_
        else:
            text = f"Not Find this Student"
        self.ui.textEdit.setText(text)

    def find_award(self):
        sid = self.ui.find_input_sid.text()
        sql_query = f"Select aname From Award,StudentAward Where StudentAward.student_id = {sid} and Award.award_id = StudentAward.award_id"
        t = execute_query(sql_query)
        text = ""
        if t:
            for _ in range(len(t)):
                name = t[_]["aname"]
                text = text + name + "\n"
        else:
            text = f"Not Find this Student"
        self.ui.textEdit.setText(text)

    def reg_reg(self):
        sid = self.ui.reg_input_sid.text()
        cid = self.ui.reg_input_cid.text()
        major = self.ui.reg_input_major.text()
        archive = self.ui.reg_input_archive.text()

        if not sid or not cid or not major:
            text = "Error,information not complete"
            self.ui.reg_label.setText(text)
            return
        sql_query = f"Select * From Student Where student.student_id = {sid};"
        t = execute_query(sql_query)
        if t:
            text = "Error,sid repeat"
            self.ui.reg_label.setText(text)
            return
        if not archive:
            archive = f"../archive/{sid}.txt"
            with open(archive, 'w') as file:
                file.write(f"sid = {sid}\n cid = {cid}\n major = {major}\n")
        sql_query = f"INSERT INTO Student (student_id, class_id, major, archive) VALUES ({sid}, {cid},'{major}','{archive}');"

        t = execute_query(sql_query)
        text = "success"
        self.ui.reg_label.setText(text)

    def change_major(self):
        sid = self.ui.reg_input_sid.text()
        major = self.ui.reg_input_major.text()
        if not sid or not major:
            text = "need information"
            self.ui.reg_label.setText(text)
            return
        sql_query = f"Select * From Student Where student.student_id = {sid};"
        t = execute_query(sql_query)
        if not t:
            text = "Not Find student"
            self.ui.reg_label.setText(text)
            return
        sql_query = f"Update Student set major = '{major}' where student.student_id = {sid};"
        t = execute_query(sql_query)
        text = "success"
        self.ui.reg_label.setText(text)

    def write_upload(self):
        sid = self.ui.write_sid.text()
        cid = self.ui.write_cid.text()
        grade = self.ui.write_grade.text()
        term = self.ui.write_term.text()

        state = "abcdefghijklmnopqrst"
        state = state[:20]

        with connection.cursor() as cursor:
            result = cursor.callproc('choose_course', args=[sid, cid, term,grade,state])
            connection.commit()
            print(result)
        self.ui.record_label.setText(state)

    def write_delete(self):
        sid = self.ui.write_sid.text()
        cid = self.ui.write_cid.text()

        state = "abcdefghijklmnopqrst"
        state = state[:20]

        with connection.cursor() as cursor:
            result = cursor.callproc('delete_grades', args=[sid, cid, state])
            connection.commit()
        self.ui.record_label.setText(state)

    def award_insert(self):
        name = self.ui.reward_name.text()
        sid = self.ui.reward_sid.text()

        state = "abcdefghijklmnopqrst"
        state = state[:20]

        with connection.cursor() as cursor:
            result = cursor.callproc('update_award_by_name', args=[sid, name, state])
            connection.commit()
        self.ui.record_label.setText(state)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    win = LoginWindow()
    # win = MainWindows()
    sys.exit(app.exec_())
