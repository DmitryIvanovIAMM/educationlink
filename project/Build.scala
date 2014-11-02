import sbt._
import Keys._

object ApplicationBuild extends Build {

  val appName = "SignUp"
  val appVersion = "1.0-SNAPSHOT"

  val appDependencies = Seq(
    "com.typesafe.slick" %% "slick" % "2.1.0-M2",
    "org.slf4j" % "slf4j-nop" % "1.6.4", 
    "com.typesafe.play" %% "play-slick" % "0.5.0.8"
  )

  val main = play.Project(appName, appVersion, appDependencies).settings(
    scalaVersion := "2.10.2"
  )

}
