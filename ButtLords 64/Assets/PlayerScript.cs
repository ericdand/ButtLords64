using UnityEngine;
using System.Collections;

public class PlayerScript : MonoBehaviour {

	// Public so it can be set from the Unity editor.
	public WaypointContainerScript waypointContainer;
	Rigidbody2D rb2d;
	float speed = 1f;

	// Use this for initialization
	void Start () {
		rb2d = GetComponent<Rigidbody2D> ();
	}
	
	// Update is called once per frame
	void Update () {
		// Go to the next waypoint.
		var waypoint = waypointContainer.GetNextWaypoint();
		if (waypoint == null)
			return; // TODO
		var direction = (waypoint.Position () - this.rb2d.position);
		if (direction.magnitude > speed) {
			direction = direction.normalized * speed;
		}
		rb2d.MovePosition(this.rb2d.position + direction);
	}
}
