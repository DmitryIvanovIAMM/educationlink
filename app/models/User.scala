package models

import scala.slick.driver.H2Driver.simple._
import scala.slick.lifted.{ProvenShape, ForeignKeyQuery} 

case class User(
                 id: Int,
                 username: String,
                 password: String,
                 email: String,
                 //firstName: String,
                 //lastName: String,
                 address1: String,
                 address2: String,
                 city: String,
                 state: String,
                 zip: String,
                 phone1_no: String,
                 phone1_type: String
                 )

//class Users(tag: Tag) extends Table[User](tag,"user") {
class Users(tag: Tag) extends Table[User](tag, "user") {
  //def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
  def id = column[Int]("id", O.PrimaryKey)

  def username = column[String]("user_login")

  def password = column[String]("user_password")

  def email = column[String]("email")

  //def firstName = column[String]("first_name")

  //def lastName = column[String]("last_name")

  def address1 = column[String]("address1")

  def address2 = column[String]("address2")

  def city = column[String]("city")

  def state = column[String]("state")

  def zip = column[String]("zip")

  def phone1_no = column[String]("phone1_no")

  def phone1_type = column[String]("phone1_type")

  // Every table needs a * projection with the same type as the table's type parameter
  def * : ProvenShape[User] =
    (id, username, password, email, address1, address2, city, state, zip, phone1_no, phone1_type)<> (User.tupled, User.unapply)
}