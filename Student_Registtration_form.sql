USE [master]
GO
/****** Object:  Database [RB_project_db]    Script Date: 22-03-2022 00:26:02 ******/
CREATE DATABASE [RB_project_db]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RB_project_db', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\RB_project_db.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'RB_project_db_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\RB_project_db_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [RB_project_db] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RB_project_db].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RB_project_db] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RB_project_db] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RB_project_db] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RB_project_db] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RB_project_db] SET ARITHABORT OFF 
GO
ALTER DATABASE [RB_project_db] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RB_project_db] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RB_project_db] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RB_project_db] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RB_project_db] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RB_project_db] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RB_project_db] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RB_project_db] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RB_project_db] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RB_project_db] SET  ENABLE_BROKER 
GO
ALTER DATABASE [RB_project_db] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RB_project_db] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RB_project_db] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RB_project_db] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RB_project_db] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RB_project_db] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RB_project_db] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RB_project_db] SET RECOVERY FULL 
GO
ALTER DATABASE [RB_project_db] SET  MULTI_USER 
GO
ALTER DATABASE [RB_project_db] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RB_project_db] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RB_project_db] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RB_project_db] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [RB_project_db] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [RB_project_db] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'RB_project_db', N'ON'
GO
ALTER DATABASE [RB_project_db] SET QUERY_STORE = OFF
GO
USE [RB_project_db]
GO
/****** Object:  Table [dbo].[class]    Script Date: 22-03-2022 00:26:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class](
	[clsid] [int] NOT NULL,
	[class] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[clsid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STUDENT]    Script Date: 22-03-2022 00:26:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STUDENT](
	[stdid] [int] NOT NULL,
	[fname] [nvarchar](max) NULL,
	[lname] [nvarchar](max) NULL,
	[roll] [nvarchar](max) NULL,
	[percentage] [nvarchar](max) NULL,
	[clssid] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[stdid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AddStudents]    Script Date: 22-03-2022 00:26:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudents]
@firstname nvarchar(max) = '', 
@lastname nvarchar(max) = '', 
@cls nvarchar(max) = '', 
@roll nvarchar(max) = '',
@percentage nvarchar(max) = ''
   as
    begin
      set nocount on;

      if coalesce(@firstname,'') = '' return 98;
	  declare @stdid int = 0;
	  declare @clsid int = 0;
	  select @stdid = isnull((select max(stdid) from student),0) + 1
	  select @clsid = isnull((select max(clsid) from class),0) + 1

      insert into student (stdid, fname, lname, roll, [percentage],clssid)
        select @stdid, @firstname, @lastname, @roll, @percentage,@clsid
        where not exists (
          select 1
          from student
          where stdid = @stdid
        )

		insert into class (clsid, class)
        select @clsid, @cls
        where not exists (
          select 1
          from class
          where clsid = @clsid
        )



      -- Check the return result to see whether a new student record was added or not
      return case when @@rowcount = 2 then 0 else 99 end;
    end
GO
/****** Object:  StoredProcedure [dbo].[getdata]    Script Date: 22-03-2022 00:26:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getdata]
  as
    begin
		select fname,lname,class from student
		inner join class on clsid = clssid

    end
GO
USE [master]
GO
ALTER DATABASE [RB_project_db] SET  READ_WRITE 
GO
