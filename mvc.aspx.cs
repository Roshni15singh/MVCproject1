using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using mvc1819_6821.Models;

namespace mvc1819_6821.Controllers
{
    public class EmployeeController : Controller
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["xyz"].ConnectionString);
        public ActionResult EmployeeForm()
        {
            return View();
        }

        public void EmployeeInsert(Emp obj)
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_emp_insert", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@name", obj.Name);
            cmd.Parameters.AddWithValue("@address", obj.Address);
            cmd.Parameters.AddWithValue("@age", obj.Age);
            cmd.Parameters.AddWithValue("@country", obj.Country);
            cmd.Parameters.AddWithValue("@state", obj.State);
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void EmployeeUpdate(Emp obj)
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_emp_update", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@empid", obj.ID);
            cmd.Parameters.AddWithValue("@name", obj.Name);
            cmd.Parameters.AddWithValue("@address", obj.Address);
            cmd.Parameters.AddWithValue("@age", obj.Age);
            cmd.Parameters.AddWithValue("@country", obj.Country);
            cmd.Parameters.AddWithValue("@state", obj.State);
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public JsonResult EmployeeGet()
        {
            string records = "";
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_emp_get", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            records = JsonConvert.SerializeObject(dt);
            return Json(records,JsonRequestBehavior.AllowGet);
        }

        public JsonResult CountryGet()
        {
            string records = "";
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from tblcountry", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            records = JsonConvert.SerializeObject(dt);
            return Json(records, JsonRequestBehavior.AllowGet);
        }

        public JsonResult StateGet(int A)
        {
            string records = "";
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from tblstate where cid='"+A+"'", con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            records = JsonConvert.SerializeObject(dt);
            return Json(records, JsonRequestBehavior.AllowGet);
        }

        public void EmployeeDelete(int ID)
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_emp_delete", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@empid", ID);
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public JsonResult EmployeeEdit(Emp obj)
        {
            string records = "";
            con.Open();
            SqlCommand cmd = new SqlCommand("usp_emp_edit", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@empid", obj.ID);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            con.Close();
            records = JsonConvert.SerializeObject(dt);
            return Json(records,JsonRequestBehavior.AllowGet);
        }
    }
}
