package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._

import views._

import models._

object Registration extends Controller {

  val registrationForm: Form[User] = Form(

    // Define a mapping that will handle User values
    mapping(
      "username" -> text(minLength = 4, maxLength = 45),
      "email" -> email,

      // Create a tuple mapping for the password/confirm
      "password" -> tuple(
        "main" -> text(minLength = 6),
        "confirm" -> text
      ).verifying(
        // Add an additional constraint: both passwords must match
        "Passwords don't match", passwords => passwords._1 == passwords._2
      ),
      "address1" -> text(maxLength = 128),
      "address2" -> text(maxLength = 128),
      "city" -> text(maxLength = 128),
      "state" -> text(maxLength = 2),
      "zip" -> text(maxLength = 5),
      "phone1_no" -> text(maxLength = 15),
      "phone1_type" -> text(maxLength = 15),

      "accept" -> checked("You must accept the conditions")
    ) {
      // The mapping signature doesn't match the User case class signature,
      // so we have to define custom binding/unbinding functions {
      // Binding: Create a User from the mapping result (ignore the second password and the accept field)
      (username, email, passwords, address1, address2, city, state, zip, phone1_no, phone1_type, _) => User(0, username, passwords._1, email, address1, address2, city, state, zip, phone1_no, phone1_type)
    } {
      // Unbinding: Create the mapping values from an existing User value
      user => Some(user.username, user.email, (user.password, ""), user.address1, user.address2, user.city, user.state, user.zip, user.phone1_no, user.phone1_type, false)
    }.verifying(
      // Add an additional constraint: The username must not be taken (you could do an SQL request here)
      "This username is not available",
      user => !Seq("admin", "guest").contains(user.username)
    )
  )

  /**
   * Display an empty form.
   */
  def form = Action {
    Ok(html.registration.form(registrationForm));
  }

  /**
   * Handle form submission.
   */
  def submit = Action {
    implicit request =>
      registrationForm.bindFromRequest.fold(
        // Form has errors, redisplay it
        errors => BadRequest(html.registration.form(errors)),

        // We got a valid User value, display the summary
        user => Ok(html.registration.summary(user))
      )
  }

}