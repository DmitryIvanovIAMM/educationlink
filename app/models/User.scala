package models

import scala.slick.driver.H2Driver.simple._

case class User(
                 id: Int,
                 username: String,
                 password: String,
                 email: String,
                 address1: String,
                 address2: String,
                 city: String,
                 state: String,
                 zip: String,
                 phone1_no: String,
                 phone1_type: String
                 )

object Users extends Table[User]("user") {
  def id = column[Int]("id", O.PrimaryKey, O.AutoInc)

  def username = column[String]("user_login")

  def password = column[String]("user_password")

  def email = column[String]("email")

  def firstName = column[String]("first_name")

  def lastName = column[String]("last_name")

  def address1 = column[String]("address1")

  def address2 = column[String]("address2")

  def city = column[String]("city")

  def state = column[String]("state")

  def zip = column[String]("zip")

  def phone1_no = column[String]("phone1_no")

  def phone1_type = column[String]("phone1_type")

  def * = id ~ username ~ password ~ email ~ address1 ~ address2 ~ city ~ state ~ zip ~ phone1_no ~ phone1_type <>(User, User.unapply _)
}
