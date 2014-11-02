package models

import scala.slick.driver.H2Driver.simple._
import scala.slick.lifted.{ ProvenShape, ForeignKeyQuery }

case class Student(
  id: Int,
  discount: Float)

//class Users(tag: Tag) extends Table[User](tag,"user") {
class Students(tag: Tag) extends Table[Student](tag, "student") {

  def id = column[Int]("id")
  def discount = column[Float]("discount")

  // Every table needs a * projection with the same type as the table's type parameter
  def * : ProvenShape[Student] = (id, discount)<> (Student.tupled, Student.unapply)

  // A reified foreign key relation that can be navigated to create a join
  def user: ForeignKeyQuery[Users, User] =
    foreignKey("user_FK", id, TableQuery[Users])(_.id)

}