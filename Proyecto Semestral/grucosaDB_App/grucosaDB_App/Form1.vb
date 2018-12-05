Imports System.Data.SqlClient

Public Class Form1
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            'esta  linea hace la conexion a la base de datos por medio de las configuraciones
            'accedidas desde app.config
            Dim conex As New SqlConnection(My.Settings.conexion)
            'envio de instrucciones sql
            Dim sql As String = "SELECT * FROM adendas"
            'variable para la ejecuccion de comandos
            Dim ejecutar As New SqlCommand(sql, conex)

            Try
                Dim AdaptadorDatos As New SqlDataAdapter(ejecutar)
                Dim EnvioDatos As New DataSet
                AdaptadorDatos.Fill(EnvioDatos, "adendas")
                Me.DataGridView1.DataSource = EnvioDatos.Tables("adendas")
            Catch es As Exception
                MsgBox(es.Message)
            End Try
        Catch ex As SqlException
            MsgBox(ex.Message)
        End Try


    End Sub
End Class
