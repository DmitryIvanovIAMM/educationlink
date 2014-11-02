package controllers

import play.api._
import play.api.mvc._

import views._
import scala.slick.driver.H2Driver.simple._

import models._

object Application extends Controller {

  // The query interface for the Users table
  val users: TableQuery[Users] = TableQuery[Users]
  // The query interface for the Students table
  val students: TableQuery[Students] = TableQuery[Students]

  // Create a connection (called a "session") to an in-memory H2 database
  val db = Database.forURL("jdbc:h2:mem:hello", driver = "org.h2.Driver")
  db.withSession { implicit session =>
    // Create the schema by combining the DDLs for the Users and Students
    // tables using the query interfaces
    (users.ddl ++ students.ddl).create

    // Insert several users
    //User(id: Int, username: String, password: String, email: String, //firstName: String, //lastName: String,
    //     address1: String, address2: String, city: String, state: String, zip: String, phone1_no: String,
    //     phone1_type: String )
    users += User(0, "Dmitry0", "ide123", "dmitry", "IAMM", "RLuxemburg str", "Donetsk", "Ukraine", "83114", "+380672812648", "mobile")
    users += User(1, "Dmitry1", "ide123", "dmitry", "IAMM", "RLuxemburg str", "Donetsk", "Ukraine", "83114", "+380672812648", "mobile")
    users += User(2, "Dmitry2", "ide123", "dmitry", "IAMM", "RLuxemburg str", "Donetsk", "Ukraine", "83114", "+380672812648", "mobile")
    users += User(3, "Dmitry3", "ide123", "dmitry", "IAMM", "RLuxemburg str", "Donetsk", "Ukraine", "83114", "+380672812648", "mobile")
    users += User(4, "Dmitry4", "ide123", "dmitry", "IAMM", "RLuxemburg str", "Donetsk", "Ukraine", "83114", "+380672812648", "mobile")
    
    // Insert students
    //student( id: Int, discount: Float)
    students += Student(0, 20)
    students += Student(0, 20)
    students += Student(1, 20)
    
    // Iterate through all users and output them
    users foreach { case User(id, username, password, email, address1, address2, city, state, zip, phone1_no, phone1_type) =>
       println(" " + id +"\t" + username +"\t" + password +"\t" + email +"\t" + address1 +"\t" + address2 +"\t" + city +"\t" + state +"\t" + zip +"\t" + phone1_no +"\t" + phone1_type)
    }
    
    // Iterate through all students
    students foreach { case Student(id, discount) => 
      println(" " + id + "\t" + discount)
    }
    
    // print discount for all users
    val q1 = for{
        user <- users
        student <- students if student.id === user.id
       } println("User "+user.username+" have discount = " + student.discount)
    // print undiscounted students
    /*val q3 = students foreach {
        case Student(id,discount) => users.filter(_.id === id) 
    } 
    q3.toList foreach println(id, discount)*/
    
    /*val q2 = for{
        student <- students
        user <- users if user.id =!= student.id
       } println("User "+user.username+" not have discount")
    */
    //} yield if (user.id == student.id) println("User "+user.username+" with ID="+user.id+" have discount ="+ student.discount)
      //      else println("User "+user.username+" with ID="+user.id+" not have discount ")
    //q1 foreach println 
  } // end of session
  def index = Action {
    Ok(html.index());
  }

}