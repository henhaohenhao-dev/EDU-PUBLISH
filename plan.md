# 部署需求计划书：

## 数据库相关

不绑定D1，配置环境可自由选择其他数据库密钥，或者自建的配置（虽然服务器自建数据库应该算是高阶操作了，我也不懂这方面，你可以在编辑完代码文件以后再跟我介绍一下）

## 对象存储相关

同样和数据库一样，不绑定CF家的R2，可选择其他家的对象存储服务或者自建

## archive的submodule相关

这个项目目前的archive是submodule，但是我并不清楚archive如果不配置，可否正常运行，这方面检查一下

## .agent部署相关

改完前面两项后，重写.agent目录下的文件，快速开始的最简步骤应该是：

1. 指引fork此仓库

2. fork完成后，clone该仓库

3. cd进clone后的目录，打开自己的agent，输入：“阅读.agent目录并根据里面的md安装配置好环境”

   - 在这个步骤中，agent会自动检查docker环境，git状态（确认有没有push的权限），如果没有就尝试自己解决，随后把astrbot+napcat的docker联排镜像拉下来，并且启动容器，注意，astrbot的挂载卷一定要有存在挂到本项目的archive目录下的内容，要写测试脚本验证这一点

   - 随后引导用户登录napcat的dashboard，指引他登录QQ账号，并且检查是否已经配置好了websocket与astrbot的通信，具体内容参考napcat文档：

     ```
     在 NapCat WebUI 页面选择 网络配置 → 新建 → WebSocket 客户端，URL 填入ws://astrbot:6199/ws，添加完成后，点击保存即可。
     https://github.com/user-attachments/assets/55c7ea6b-177d-4d25-a6ee-6240b23a3164 #此为示例截图
     ```

     

   - 然后指引用户登录astrbot的dashboard，并且配置好onebotv11的机器人配置，参考以下文档：

     ```
     ## 1. 配置 OneBot v11
     
     1. 进入 AstrBot 的 WebUI
     2. 点击左边栏 `机器人`
     3. 然后在右边的界面中，点击 `+ 创建机器人`
     4. 选择 `OneBot v11`
     
     在出现的表单中，填写：
     
     - ID(id)：随意填写，仅用于区分不同的消息平台实例。
     - 启用(enable): 勾选。
     - 反向 WebSocket 主机地址：请填写你的机器的 IP 地址，一般情况下请直接填写 `0.0.0.0`
     - 反向 WebSocket 端口：填写一个端口，默认为 `6199`。
     - 反向 Websocket Token：只有当 NapCat 网络配置中配置了 token 才需填写。
     
     点击 `保存`。
     
     ## 2. 配置协议实现端
     
     请参阅对应的协议实现端项目的部署文档。
     
     一些注意点：
     
     1. 协议实现端需要支持 `反向 WebSocket` 实现，及 AstrBot 端作为服务端，实现端作为客户端。
     2. `反向 WebSocket` 的 URL 为 `ws(s)://<your-host>:6199/ws`。
     
     ## 3. 验证
     
     前往 AstrBot WebUI `控制台`，如果出现 ` aiocqhttp(OneBot v11) 适配器已连接。` 蓝色的日志，说明连接成功。如果没有，若干秒后出现` aiocqhttp 适配器已被关闭` 则为连接超时（失败），请检查配置是否正确。
     ```

    - 随后指引用户安装本项目专用astrbot插件，插件仓库地址：[guiguisocute/astrbot-QQtoLocal](https://github.com/guiguisocute/astrbot-QQtoLocal)，并指引用户配置好插件里的各项配置
    - 让用户在来源群里发几条消息，看是否能成功自动归档

4. 指引用户在dashboard配置好cloudflare page绑定他的fork仓库，注意test和main分支与生产和测试分开

5. （可选）安装Wrangler，指引用户登录，然后创建R2，D1，绑定pages和.env
