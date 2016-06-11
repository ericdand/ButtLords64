using UnityEngine;
using System.Collections;

public class PlayerScript : MonoBehaviour {

	// Public so it can be set from the Unity editor.
	public WaypointContainerScript waypointContainer;
	Rigidbody2D rb2d;
	float speed = 0.1f;

	// Use this for initialization
	void Start () {
		rb2d = GetComponent<Rigidbody2D> ();
	}
		
	private bool withinEpsilon (Vector3 a, Vector3 b, float e) {
		// Debug.Log("dx: " + (a.x - b.x) + "\ndy: " + (a.y - b.y) + "\ndz: " + (a.z + b.z));
		return (Mathf.Abs (a.x - b.x) <= e
			&& Mathf.Abs (a.y - b.y) <= e
			&& Mathf.Abs (a.z - b.z) <= e);
	}

	// Update is called once per frame
	void Update () {
		// Go to the next waypoint.
		var waypoint = waypointContainer.GetNextWaypoint();
		if (waypoint != null) {
			var width = this.GetComponent<BoxCollider2D> ().size.x;
			if (withinEpsilon (waypoint.transform.position, this.transform.position, width / 2)) {
				waypoint.isVisited = true;
				Debug.Log ("I AM VISITED!");
			}
			var direction = (waypoint.Position () - this.rb2d.position);
			if (direction.magnitude > speed) {
				direction = direction.normalized * speed;
			}
			rb2d.MovePosition (this.rb2d.position + direction);
		}
	}
}
