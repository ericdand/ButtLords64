using UnityEngine;
using System.Collections;

public class SmoothDampFollowPlayer : MonoBehaviour {

	public Transform target;

	private Vector3 velocity;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		var target3d = new Vector3 (target.position.x, target.position.y, this.transform.position.z);
		this.transform.position = Vector3.SmoothDamp (
			this.transform.position, target3d, ref velocity, 0.15f);
	}
}
