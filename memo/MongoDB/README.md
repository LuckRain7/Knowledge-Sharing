# MongoDB

## 1. 常用操作

```bash
# 列出全部数据库
show dbs 

# 创建数据库/进入数据库
use dbname

# 检查当前数据库(返回当前数据库名称)
db

# 写入数据（新建数据库需写入一条数据占位，防止空数据库被删除）
db.site.insert({"func":"占位"})
```

## 2. 数据库权限

具体角色的功能： 

- Read：允许用户读取指定数据库
- readWrite：允许用户读写指定数据库
- dbAdmin：允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
- userAdmin：允许用户向system.users集合写入，可以找指定数据库里创建、删除和管理用户
- clusterAdmin：只在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限。
- readAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读权限
- readWriteAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读写权限
- userAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的userAdmin权限
- dbAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限。
- root：只在admin数据库中可用。超级账号，超级权限

```bash
# 创建权限
db.createUser({ user: "useradmin", pwd: "adminpassword", roles: [{ role: "readWrite", db: "dbname" }] })

# 删除用户
db.dropUser('rainbook')

# 查看对应数据库账户
use dbname
show users
```



## 3. 启动 MongoDB

### 3.1 参数启动

```bash
mongod --dbpath C:\data\db --bind_ip_all
```

### 3.2 配置文件启动

`bin` 目录下创建

```
dbpath=C:/Users/Administrator/Desktop/mongodb/data
logpath=C:/Users/Administrator/Desktop/mongodb/log/mongodb.log
port=27017
logappend=true
bind_ip=0.0.0.0
auth=true
```

启动： mongod.exe -f  mongodb.conf



## 4.  设置 MongoDB 权限

```bash
# 启动mongod
mongod --dbpath C:\data\db

# 进入admin数据库
use admin

# 设置角色权限
db.createUser({user:'username', pwd: 'password',roles: [{role: 'userAdminAnyDatabase', 'db': 'admin'}]})

# 创建型数据库
use bookmarks

# 数据库管理员
db.createUser({ user: "username", pwd: "password", roles: [{ role: "readWrite", db: "bookmarks" }] })

# 创建数据库权限
db.auth('username', 'password')

# 填充数据防止删除
db.site.insert({"func":"占位"})


```

## 5.  错误处理

### 1. too many users are authenticated

```bash
WriteCommandError({
        "ok" : 0,
        "errmsg" : "too many users are authenticated",
        "code" : 13,
        "codeName" : "Unauthorized"
})
```

MongoDB 只允许一位用户登录，切换用户需先退出后重启

## 6. Mongoose

### 6.1 Schema

```typescript
import * as mongoose from 'mongoose'

const Schema = mongoose.Schema;

const schema = new Schema({
    name: { type: String, },
    id: { type: Number },
    pid: { type: Number },
    category: { type: mongoose.Schema.Types.ObjectId, ref: "Category" }, // ts
    category: { type: mongoose.SchemaTypes.ObjectId, ref: "Category" } // js
});

const Category = mongoose.model('Category', schema, 'Category')

export default Category
```

### 6.2  CURD

- 增加(C): model.create | model..collection.insert
- 修改(U):model.update | model.findByIdAndUpdate | model.findOneUpdate
- 查询(R): model.find | model.findOne | model.findById
- 删除(D):model.remove | model.findByIdAndRemove | model.findOneRemove

```javascript
import { Request, Response } from "express";
import Category from '../MongoDB/models/Category'

class CategoryController {
    static get = async (req: Request, res: Response) => {
        Category.find({}, (err, data) => {
            if (err) {
                res.send(err)
            }
            res.send({
                code: 0,
                data: data
            })
        })
    }
    static init = async (req: Request, res: Response) => {
        Category.collection.insert(initData, (err, allInfo) => {
            if (err) {
                res.send(err)
            }
            res.send(allInfo)
        })
    }

    static getById = async (req: Request, res: Response) => {
        Category.findById(req.params.id, (err, userInfo) => {
            if (err) {
                res.send(err)
            }
            res.send(userInfo)
        })
    }

    static post = async (req: Request, res: Response) => {
        Category.create(req.body, (err, info) => {
            if (err) {
                res.send(err)
            }
            res.send(info)
        })
    }

    static put = async (req: Request, res: Response) => {
        const body = req.body
        Category.findOneAndUpdate({ _id: body._id }, body, (err, userInfo) => {
            if (err) {
                res.send({ code: 1, err })
            }
            res.send({ code: 0 })
        })
    }

    static delete = async (req: Request, res: Response) => {
        Category.remove({ _id: req.params.id }, (err) => {
            if (err) {
                res.send({ code: 1, err })
            }
            res.send({ code: 0 })
        })
    }
}

export { adminController, CategoryController } 
```

