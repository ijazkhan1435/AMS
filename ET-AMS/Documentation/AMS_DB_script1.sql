USE [master]
GO
/****** Object:  Database [AMS]    Script Date: 30/05/2024 11:48:05 am ******/
CREATE DATABASE [AMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AMS', FILENAME = N'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AMS_log', FILENAME = N'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AMS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [AMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AMS] SET  MULTI_USER 
GO
ALTER DATABASE [AMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AMS] SET QUERY_STORE = ON
GO
ALTER DATABASE [AMS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AMS]
GO
/****** Object:  Table [dbo].[tblAsset]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAsset](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AssetNo] [nvarchar](50) NOT NULL,
	[AssetDesc] [nvarchar](max) NULL,
	[AssetClass] [nvarchar](50) NULL,
	[AssetClassDesc] [nvarchar](max) NULL,
	[AssetSubType] [nvarchar](50) NULL,
	[AssetSubTypeDesc] [nvarchar](max) NULL,
	[TotalQuantity] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreateTimeStamp] [datetime] NULL,
	[isApproved] [bit] NULL,
	[ApprovedBy] [int] NULL,
	[ApproveTimeStamp] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_tblAsset] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetAudit]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetAudit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Branch] [nvarchar](50) NULL,
	[Warehouse] [nvarchar](50) NULL,
	[AssetNo] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](max) NULL,
	[SerialNumber] [nvarchar](50) NULL,
	[InventoryNumber] [nvarchar](50) NULL,
	[AuditQuantity] [int] NULL,
	[InsuranceStatus] [nvarchar](50) NULL,
	[InsuranceStatuDesc] [nvarchar](max) NULL,
	[UsefulLifeInYrs] [int] NULL,
	[TagStatus] [nvarchar](50) NULL,
	[TagStatusDescription] [nvarchar](max) NULL,
	[AuditStatus] [int] NULL,
	[AuditBy] [int] NULL,
	[AuditTimeStamp] [datetime] NULL,
	[ReAudit] [bit] NULL,
	[AuditReason] [nvarchar](max) NULL,
 CONSTRAINT [PK_tblAssetAudit] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAssetImport]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssetImport](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Branch] [nvarchar](50) NULL,
	[Warehouse] [nvarchar](50) NULL,
	[AssetNo] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](max) NULL,
	[SerialNumber] [nvarchar](50) NULL,
	[InventoryNumber] [nvarchar](50) NULL,
	[ImportQuantity] [int] NULL,
	[InsuranceStatus] [nvarchar](50) NULL,
	[InsuranceStatuDesc] [nvarchar](max) NULL,
	[UsefulLifeInYrs] [int] NULL,
	[TagStatus] [nvarchar](50) NULL,
	[TagStatusDescription] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[ImportedBy] [int] NULL,
	[ImportTimeStamp] [datetime] NULL,
	[isApproved] [bit] NULL,
	[ApproveTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblAssetImport] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBranch]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBranch](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Branch] [nvarchar](50) NOT NULL,
	[BranchDesc] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreateTimeStamp] [datetime] NULL,
	[isApproved] [bit] NULL,
	[ApprovedBy] [int] NULL,
	[ApproveTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblBranch] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblLocation]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLocation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[LocationDesc] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreateTimeStamp] [datetime] NULL,
	[isApproved] [bit] NULL,
	[ApprovedBy] [int] NULL,
	[ApproveTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblLocation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWarehouse]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWarehouse](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Warehouse] [nvarchar](50) NOT NULL,
	[WarehouseDesc] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreateTimeStamp] [datetime] NULL,
	[isApproved] [bit] NULL,
	[ApprovedBy] [int] NULL,
	[ApproveTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblWarehouse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfile](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[RollsID] [int] NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[IsEnabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[RollsId] [int] IDENTITY(1,1) NOT NULL,
	[RollsDesc] [varchar](100) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRolesPermission]    Script Date: 30/05/2024 11:48:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRolesPermission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL,
	[Module] [varchar](100) NOT NULL,
	[Permission] [nvarchar](50) NOT NULL,
	[RollsId] [int] NOT NULL,
	[IsEnable] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Action] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblAsset] ADD  CONSTRAINT [DF_tblAsset_CreateTimeStamp]  DEFAULT (getdate()) FOR [CreateTimeStamp]
GO
ALTER TABLE [dbo].[tblAsset] ADD  CONSTRAINT [DF_tblAsset_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[tblAsset] ADD  CONSTRAINT [DF_tblAsset_ApproveTimeStamp]  DEFAULT (getdate()) FOR [ApproveTimeStamp]
GO
ALTER TABLE [dbo].[tblAsset] ADD  CONSTRAINT [DF_tblAsset_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[tblAssetAudit] ADD  CONSTRAINT [DF_tblAssetAudit_AuditTimeStamp]  DEFAULT (getdate()) FOR [AuditTimeStamp]
GO
ALTER TABLE [dbo].[tblAssetAudit] ADD  CONSTRAINT [DF_tblAssetAudit_ReAudit]  DEFAULT ((0)) FOR [ReAudit]
GO
ALTER TABLE [dbo].[tblAssetImport] ADD  CONSTRAINT [DF_tblAssetImport_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[tblAssetImport] ADD  CONSTRAINT [DF_tblAssetImport_ImportTimeStamp]  DEFAULT (getdate()) FOR [ImportTimeStamp]
GO
ALTER TABLE [dbo].[tblAssetImport] ADD  CONSTRAINT [DF_tblAssetImport_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[tblAssetImport] ADD  CONSTRAINT [DF_tblAssetImport_ApproveTimeStamp]  DEFAULT (getdate()) FOR [ApproveTimeStamp]
GO
ALTER TABLE [dbo].[tblBranch] ADD  CONSTRAINT [DF_tblBranch_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[tblBranch] ADD  CONSTRAINT [DF_tblBranch_CreateTimeStamp]  DEFAULT (getdate()) FOR [CreateTimeStamp]
GO
ALTER TABLE [dbo].[tblBranch] ADD  CONSTRAINT [DF_tblBranch_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[tblBranch] ADD  CONSTRAINT [DF_tblBranch_ApproveTimeStamp]  DEFAULT (getdate()) FOR [ApproveTimeStamp]
GO
ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_CreateTimeStamp]  DEFAULT (getdate()) FOR [CreateTimeStamp]
GO
ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[tblLocation] ADD  CONSTRAINT [DF_tblLocation_ApproveTimeStamp]  DEFAULT (getdate()) FOR [ApproveTimeStamp]
GO
ALTER TABLE [dbo].[tblWarehouse] ADD  CONSTRAINT [DF_tblWarehouse_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[tblWarehouse] ADD  CONSTRAINT [DF_tblWarehouse_CreateTimeStamp]  DEFAULT (getdate()) FOR [CreateTimeStamp]
GO
ALTER TABLE [dbo].[tblWarehouse] ADD  CONSTRAINT [DF_tblWarehouse_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[tblWarehouse] ADD  CONSTRAINT [DF_tblWarehouse_ApproveTimeStamp]  DEFAULT (getdate()) FOR [ApproveTimeStamp]
GO
USE [master]
GO
ALTER DATABASE [AMS] SET  READ_WRITE 
GO
