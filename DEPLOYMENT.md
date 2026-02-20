# Deployment Guide......

## Backend Deployment on Render

### Step 1: Prepare Your Repository

1. Push your code to GitHub (including the `backend` folder)
2. Make sure `.gitignore` excludes `node_modules` and `.env`

### Step 2: Create Render Account

1. Go to [render.com](https://render.com)
2. Sign up or log in with GitHub

### Step 3: Deploy Backend

1. Click "New +" → "Web Service"
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `multigames-backend` (or your choice)
   - **Region**: Choose closest to your users
   - **Branch**: `main` (or your default branch)
   - **Root Directory**: `backend`
   - **Runtime**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Instance Type**: Free (or paid for better performance)

4. Add Environment Variables:
   - `PORT`: 3000 (optional, Render sets this automatically)
   - `NODE_ENV`: production
   - `CORS_ORIGIN`: * (or your specific domain)

5. Click "Create Web Service"

### Step 4: Get Your Backend URL

After deployment completes (2-3 minutes), you'll get a URL like:
```
https://multigames-backend.onrender.com
```

### Step 5: Update Flutter App

1. Open `lib/config/socket_config.dart`
2. Replace the `serverUrl` with your Render URL:
```dart
static const String serverUrl = 'https://your-app-name.onrender.com';
```

### Step 6: Test Connection

1. Run your Flutter app
2. Try creating a room
3. Check Render logs if there are issues (Dashboard → Logs)

## Important Notes

### Free Tier Limitations
- Render free tier spins down after 15 minutes of inactivity
- First request after spin-down takes 30-60 seconds
- Consider upgrading to paid tier ($7/month) for always-on service

### Custom Domain (Optional)
1. Go to Settings → Custom Domain
2. Add your domain
3. Update DNS records as instructed
4. Update `CORS_ORIGIN` environment variable

### Monitoring
- Check logs: Dashboard → Your Service → Logs
- View metrics: Dashboard → Your Service → Metrics
- Set up alerts: Dashboard → Your Service → Notifications

## Troubleshooting

### Connection Issues
1. Check Render logs for errors
2. Verify environment variables are set
3. Test backend health: `https://your-url.onrender.com/`
4. Check CORS settings

### Socket.IO Issues
1. Ensure WebSocket is enabled (default on Render)
2. Check client is using correct URL
3. Verify no firewall blocking WebSocket

### Performance Issues
1. Upgrade to paid tier for better performance
2. Choose region closer to users
3. Monitor memory usage in Render dashboard

## Alternative Deployment Options

### Railway
1. Similar to Render
2. Better free tier (500 hours/month)
3. Visit [railway.app](https://railway.app)

### Heroku
1. No free tier anymore
2. Starts at $5/month
3. Visit [heroku.com](https://heroku.com)

### DigitalOcean App Platform
1. $5/month minimum
2. More control
3. Visit [digitalocean.com](https://digitalocean.com)

### Self-Hosted (VPS)
1. Cheapest long-term option
2. Requires server management
3. Options: DigitalOcean Droplet, AWS EC2, Linode
