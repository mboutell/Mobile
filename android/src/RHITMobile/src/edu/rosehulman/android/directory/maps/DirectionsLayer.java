package edu.rosehulman.android.directory.maps;

import java.io.InputStream;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Paint.Cap;
import android.graphics.Paint.Join;
import android.graphics.Paint.Style;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;
import com.google.android.maps.Projection;
import com.readystatesoftware.mapviewballoons.BalloonItemizedOverlay;

import edu.rosehulman.android.directory.R;
import edu.rosehulman.android.directory.TaskManager;
import edu.rosehulman.android.directory.model.Directions;
import edu.rosehulman.android.directory.model.Path;
import edu.rosehulman.android.directory.util.BoundingBox;

/**
 * Overlay containing Point Of Interest markers
 */
public class DirectionsLayer extends BalloonItemizedOverlay<OverlayItem> implements ManageableOverlay {

	private static Drawable transparent;
	
	private OverlayManagerControl manager;
	private TaskManager taskManager;
	
	private Directions directions;
	public BoundingBox bounds;
	
	private int nodeCount;
	private Path pathNodes[];
	
	private boolean animate = true;

	public DirectionsLayer(MapView mapView, TaskManager taskManager, Directions directions) {
		super(boundCenter(getDirectionsDrawable(mapView.getResources(), DirectionsBitmap.NODE)), mapView);
		this.taskManager = taskManager;
		this.directions = directions;

		if (transparent == null) {
			transparent = getMapView().getResources().getDrawable(android.R.color.transparent);
		}
		
		bounds = directions.getBounds();

		nodeCount = 2;
		for (Path path : directions.paths) {
			if (path.dir != null)
				nodeCount++;
		}
		pathNodes = new Path[nodeCount-1];
		int i = 0;
		for (Path path : directions.paths) {
			if (path.dir != null) {
				pathNodes[i] = path;
				i++;
			}
		}
		pathNodes[i] = directions.paths[directions.paths.length-1];
		
		pathPaint = new Paint();
		pathPaint.setStyle(Style.STROKE);
		pathPaint.setColor(mapView.getResources().getColor(R.color.light_blue));
		pathPaint.setAlpha(200);
		pathPaint.setStrokeCap(Cap.ROUND);
		pathPaint.setStrokeJoin(Join.BEVEL);
		pathPaint.setStrokeWidth(10);
		
		populate();
	}

	@Override
	protected OverlayItem createItem(int i) {
		OverlayItem overlay;
		
		if (i == 0) {
			overlay = new OverlayItem(directions.start.asGeoPoint(), "Starting location", "");
			overlay.setMarker(boundCenterBottom(getDirectionsDrawable(getMapView().getResources(), DirectionsBitmap.START)));
		} else {
			Path path = pathNodes[i-1];
			overlay = new OverlayItem(path.dest.asGeoPoint(), path.dir, "");

			if (path.flag) {
				overlay.setMarker(boundCenterBottom(getDirectionsDrawable(getMapView().getResources(), DirectionsBitmap.END)));
			}
		}
		
		return overlay;
	}

	@Override
	public int size() {
		return nodeCount;
	}
	
	@Override
	protected boolean onBalloonTap(int index, OverlayItem item) {
		//TODO show directions list
		
		return true;
	}
	
	@Override
	protected void animateTo(int index, GeoPoint center) {
		if (manager != null) {
			manager.markSelected();
		}
		MapView mapView = getMapView();
		ViewController controller = new ViewController(mapView);
		Point pt = new Point(mapView.getWidth() / 2, mapView.getHeight() / 2);
		int spanLat = bounds.top - bounds.bottom;
		int spanLon = bounds.left - bounds.right;
		controller.animateTo(center, pt, spanLat, spanLon, animate);
	}
	
	private Paint pathPaint;
	private Point pt;
	
	@Override
	public void draw(Canvas canvas, MapView mapView, boolean shadow) {
		if (shadow) {
			super.draw(canvas, mapView, shadow);
			return;
		}
		
		Projection proj = mapView.getProjection();
		android.graphics.Path directionsPath = new android.graphics.Path();
		
		pt = proj.toPixels(directions.start.asGeoPoint(), pt);
		directionsPath.moveTo(pt.x, pt.y);
		
		for (Path path : directions.paths) {
			proj.toPixels(path.dest.asGeoPoint(), pt);
			directionsPath.lineTo(pt.x, pt.y);
		}
		
		canvas.drawPath(directionsPath, pathPaint);
		
		super.draw(canvas, mapView, shadow);
	}
	
	@Override
	public void clearSelection() {
		this.setFocus(null);
	}

	@Override
	public void setManager(OverlayManagerControl manager) {
		this.manager = manager;
	}
	
	private enum DirectionsBitmap {
		START,
		END,
		NODE,
		SHADOW
	}
	
	private static Bitmap directionsBitmap;
	private static Drawable getDirectionsDrawable(Resources resources, DirectionsBitmap type) {
		if (directionsBitmap == null) { 
			InputStream fin = resources.openRawResource(R.drawable.directions_map_pins);
			directionsBitmap = BitmapFactory.decodeStream(fin);
		}
		
		int x = type.ordinal() * 34;
		return new BitmapDrawable(resources, Bitmap.createBitmap(directionsBitmap,
				x, 0, 34, 61));
	}
	
}
